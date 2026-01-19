// Auth service - Google Sign-In + API token management
// Uses Google Sign-In for initial auth, then exchanges for long-lived API tokens

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../core/logging/app_logger.dart';

class AuthService {
  factory AuthService() => _instance;
  AuthService._internal();
  static final AuthService _instance = AuthService._internal();

  static const _channel = MethodChannel('com.zeroclick/background');
  // iOS client ID from GoogleService-Info.plist
  static const _iosClientId = '269285054406-ft7anq4an8h6d4rh8mmnjca8c67uda96.apps.googleusercontent.com';
  // Server client ID for backend token verification
  static const _serverClientId = '269285054406-mehvd44e88dfk6tbl69rou5g920r3lq1.apps.googleusercontent.com';
  static const _log = AppLogger('AuthService');

  // Prefs keys for session persistence
  static const _keyWasSignedIn = 'google_was_signed_in';
  static const _keyUserEmail = 'google_user_email';
  static const _keyAccessToken = 'api_access_token';
  static const _keyRefreshToken = 'api_refresh_token';
  static const _keyTokenExpiry = 'api_token_expiry';

  final _googleSignIn = GoogleSignIn.instance;

  // State management
  GoogleSignInAccount? _currentUser;
  String? _accessToken;
  String? _refreshToken;
  DateTime? _tokenExpiry;
  String? _storedEmail; // Email from SharedPreferences (survives Google session expiry)
  bool _initialized = false;

  // API base URL - will be set by AppProvider
  String _apiBaseUrl = 'https://mileage-api-ivdikzmo7a-ez.a.run.app';

  // Stream for auth state changes
  final _userController = StreamController<GoogleSignInAccount?>.broadcast();
  Stream<GoogleSignInAccount?> get userStream => _userController.stream;
  StreamSubscription<GoogleSignInAuthenticationEvent>? _authSubscription;

  GoogleSignInAccount? get currentUser => _currentUser;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  String? get userEmail => _currentUser?.email ?? _storedEmail;
  // User is signed in if we have a valid access token (don't require Google session)
  bool get isSignedIn => _accessToken != null;

  /// Check if token is expired or about to expire (within 5 minutes)
  bool get isTokenExpired {
    if (_tokenExpiry == null) return true;
    return DateTime.now().isAfter(_tokenExpiry!.subtract(const Duration(minutes: 5)));
  }

  /// Set API base URL
  void setApiBaseUrl(String url) {
    _apiBaseUrl = url;
  }

  Future<void> init() async {
    if (_initialized) return;

    try {
      _log.info('Initializing...');

      // Initialize GoogleSignIn with both client IDs
      await _googleSignIn.initialize(
        clientId: _iosClientId,
        serverClientId: _serverClientId,
      );
      _initialized = true;

      // Set up auth events listener
      _authSubscription = _googleSignIn.authenticationEvents.listen(
        _handleAuthenticationEvent,
        onError: _handleAuthenticationError,
      );

      // Load stored tokens
      await _loadStoredTokens();

      // Check if user was previously signed in
      final wasSignedIn = await _wasUserSignedIn();
      _log.info('Was previously signed in: $wasSignedIn, hasToken=${_accessToken != null}, hasRefresh=${_refreshToken != null}');

      if (wasSignedIn) {
        // If we have valid API tokens, we're good - just refresh if needed
        if (_accessToken != null) {
          if (isTokenExpired && _refreshToken != null) {
            _log.info('Token expired, refreshing...');
            await refreshAccessToken();
          }
          // We have API tokens - no need for Google session
          _log.info('Session restored with API tokens');
        } else if (_refreshToken != null) {
          // No access token but have refresh - try to refresh
          _log.info('No access token, trying refresh...');
          final refreshed = await refreshAccessToken();
          if (!refreshed) {
            // Refresh failed - need fresh Google sign in
            await _autoSignIn();
          }
        } else {
          // No tokens at all - need fresh sign in
          await _autoSignIn();
        }
      }

    } on Exception catch (e) {
      _log.error('Init error: $e');
      _initialized = true;
    }
  }

  Future<void> _loadStoredTokens() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString(_keyAccessToken);
    _refreshToken = prefs.getString(_keyRefreshToken);
    _storedEmail = prefs.getString(_keyUserEmail);
    final expiryMs = prefs.getInt(_keyTokenExpiry);
    if (expiryMs != null) {
      _tokenExpiry = DateTime.fromMillisecondsSinceEpoch(expiryMs);
    }
    _log.info('Loaded stored tokens: access=${_accessToken != null}, refresh=${_refreshToken != null}, email=$_storedEmail');
  }

  Future<void> _saveTokens(String accessToken, String refreshToken, int expiresIn) async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _tokenExpiry = DateTime.now().add(Duration(seconds: expiresIn));

    await prefs.setString(_keyAccessToken, accessToken);
    await prefs.setString(_keyRefreshToken, refreshToken);
    await prefs.setInt(_keyTokenExpiry, _tokenExpiry!.millisecondsSinceEpoch);

    // Sync to Keychain for Watch
    await _syncTokensToKeychain();
  }

  Future<void> _clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = null;
    _refreshToken = null;
    _tokenExpiry = null;

    await prefs.remove(_keyAccessToken);
    await prefs.remove(_keyRefreshToken);
    await prefs.remove(_keyTokenExpiry);

    // Clear from Keychain
    await _syncTokensToKeychain();
  }

  Future<bool> _wasUserSignedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyWasSignedIn) ?? false;
  }

  Future<void> _saveSignedInState(bool signedIn, {String? email}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyWasSignedIn, signedIn);
    if (email != null) {
      await prefs.setString(_keyUserEmail, email);
    } else if (!signedIn) {
      await prefs.remove(_keyUserEmail);
    }
  }

  /// Try to restore Google session in background (non-blocking, fire-and-forget)
  /// This is optional - we can work with just API tokens
  void _tryRestoreGoogleSession() {
    Future(() async {
      try {
        if (!_googleSignIn.supportsAuthenticate()) return;

        final user = await _googleSignIn.authenticate(
          scopeHint: ['openid', 'email', 'profile'],
        );
        _currentUser = user;
        _userController.add(_currentUser);
        _log.info('Google session restored: ${user.email}');
      } on Exception catch (e) {
        // This is fine - we can work without Google session
        _log.info('Google session restore skipped: $e');
      }
    });
  }

  Future<void> _autoSignIn() async {
    try {
      _log.info('Auto sign-in...');

      if (!_googleSignIn.supportsAuthenticate()) {
        _log.warning('authenticate() not supported');
        return;
      }

      // authenticate() uses cached credentials - should not show UI if session valid
      final user = await _googleSignIn.authenticate(
        scopeHint: ['openid', 'email', 'profile'],
      );

      _currentUser = user;
      _userController.add(_currentUser);
      _log.info('Auto sign-in success: ${user.email}');

      // If we don't have valid API tokens yet, exchange Google token for them
      if (_accessToken == null || isTokenExpired) {
        if (_refreshToken != null) {
          // Try to refresh first
          final refreshed = await refreshAccessToken();
          if (!refreshed) {
            // Refresh failed - exchange Google token
            await _exchangeGoogleToken(user);
          }
        } else {
          // No refresh token - exchange Google token
          await _exchangeGoogleToken(user);
        }
      }

    } on GoogleSignInException catch (e) {
      _log.warning('Auto sign-in failed: ${e.code.name} - ${e.description}');
      // Only clear signed-in state if we don't have valid API tokens
      if (e.code != GoogleSignInExceptionCode.canceled && _accessToken == null) {
        await _saveSignedInState(false);
      }
    } on Exception catch (e) {
      _log.error('Auto sign-in error: $e');
    }
  }

  void _handleAuthenticationEvent(GoogleSignInAuthenticationEvent event) {
    _log.info('Auth event: ${event.runtimeType}');

    switch (event) {
      case GoogleSignInAuthenticationEventSignIn():
        _currentUser = event.user;
        _userController.add(_currentUser);
        _saveSignedInState(true, email: event.user.email);

      case GoogleSignInAuthenticationEventSignOut():
        _currentUser = null;
        _userController.add(null);
        _saveSignedInState(false);
        _clearTokens();
    }
  }

  void _handleAuthenticationError(Object error) {
    _log.error('Auth stream error: $error');
  }

  /// Exchange Google ID token for API access/refresh tokens
  Future<bool> _exchangeGoogleToken(GoogleSignInAccount user) async {
    try {
      final auth = user.authentication;
      final googleIdToken = auth.idToken;

      if (googleIdToken == null) {
        _log.error('No Google ID token available');
        return false;
      }

      _log.info('Exchanging Google token for API tokens...');

      final response = await http.post(
        Uri.parse('$_apiBaseUrl/auth/token'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'google_token': googleIdToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        await _saveTokens(
          data['access_token'] as String,
          data['refresh_token'] as String,
          data['expires_in'] as int,
        );
        _log.info('Token exchange successful');
        return true;
      } else {
        _log.error('Token exchange failed: ${response.statusCode} ${response.body}');
        return false;
      }
    } on Exception catch (e) {
      _log.error('Token exchange error: $e');
      return false;
    }
  }

  Future<bool> signIn() async {
    if (!_initialized) await init();

    try {
      _log.info('Sign in...');

      if (!_googleSignIn.supportsAuthenticate()) {
        _log.warning('authenticate() not supported on this platform');
        return false;
      }

      // Google Sign-In
      final user = await _googleSignIn.authenticate(
        scopeHint: ['openid', 'email', 'profile'],
      );

      _currentUser = user;
      _userController.add(_currentUser);
      await _saveSignedInState(true, email: user.email);

      // Exchange Google token for API tokens
      final success = await _exchangeGoogleToken(user);

      _log.info('Sign in done. User=${user.email}, hasToken=$success');
      return success;

    } on GoogleSignInException catch (e) {
      _log.warning('GoogleSignInException: ${e.code.name} - ${e.description}');
      return false;
    } on Exception catch (e) {
      _log.error('Sign in error: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    // Revoke tokens on server
    try {
      if (_accessToken != null) {
        await http.post(
          Uri.parse('$_apiBaseUrl/auth/logout'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_accessToken',
          },
        );
      }
    } on Exception catch (e) {
      _log.warning('Server logout failed: $e');
    }

    await _googleSignIn.signOut();
    _currentUser = null;
    _userController.add(null);
    await _saveSignedInState(false);
    await _clearTokens();
    _log.info('Signed out');
  }

  /// Refresh the access token using the refresh token
  /// Returns true if refresh was successful
  Future<bool> refreshAccessToken() async {
    if (_refreshToken == null) {
      _log.warning('No refresh token available');
      return false;
    }

    try {
      _log.info('Refreshing access token...');

      final response = await http.post(
        Uri.parse('$_apiBaseUrl/auth/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refresh_token': _refreshToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final newAccessToken = data['access_token'] as String;
        final expiresIn = data['expires_in'] as int;

        // Update access token (keep same refresh token)
        final prefs = await SharedPreferences.getInstance();
        _accessToken = newAccessToken;
        _tokenExpiry = DateTime.now().add(Duration(seconds: expiresIn));

        await prefs.setString(_keyAccessToken, newAccessToken);
        await prefs.setInt(_keyTokenExpiry, _tokenExpiry!.millisecondsSinceEpoch);

        // Sync to Keychain for Watch
        await _syncTokensToKeychain();

        _log.info('Token refreshed successfully');
        return true;
      } else if (response.statusCode == 401) {
        // Refresh token expired/invalid - need to re-authenticate
        _log.warning('Refresh token invalid/expired');
        await _clearTokens();
        return false;
      } else {
        _log.error('Token refresh failed: ${response.statusCode}');
        return false;
      }
    } on Exception catch (e) {
      _log.error('Token refresh error: $e');
      return false;
    }
  }

  /// Get a valid token, refreshing if necessary
  /// Returns null if unable to get a valid token (re-auth needed)
  Future<String?> getValidToken() async {
    if (_accessToken == null) return null;

    if (isTokenExpired) {
      final refreshed = await refreshAccessToken();
      if (!refreshed) {
        // Try to re-authenticate with Google
        if (_currentUser != null) {
          final success = await _exchangeGoogleToken(_currentUser!);
          if (!success) return null;
        } else {
          return null;
        }
      }
    }

    return _accessToken;
  }

  /// Refresh token callback for ApiClient - returns new token or null
  Future<String?> refreshTokenForApi() async {
    final refreshed = await refreshAccessToken();
    return refreshed ? _accessToken : null;
  }

  Future<void> _syncTokensToKeychain() async {
    try {
      // Sync access token to Keychain (and refresh token for Watch to use)
      await _channel.invokeMethod<void>('setAuthToken', {
        'token': _accessToken ?? '',
        'refreshToken': _refreshToken ?? '',
      });
      _log.info('Tokens synced to Keychain');
    } on PlatformException catch (e) {
      _log.warning('Keychain sync failed: $e');
    }
  }

  Future<void> syncTokenToWatch() async {
    await _syncTokensToKeychain();
  }

  Map<String, String> getAuthHeaders() => {
        'Content-Type': 'application/json',
        if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
        if (_currentUser?.email != null) 'X-User-Email': _currentUser!.email,
      };

  Future<Map<String, String>> getAuthHeadersAsync() async {
    await getValidToken();
    return getAuthHeaders();
  }

  void dispose() {
    _authSubscription?.cancel();
    _userController.close();
  }
}
