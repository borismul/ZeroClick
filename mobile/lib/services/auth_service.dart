// Google Sign-In service with Identity Platform token support

import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    // Server client ID for backend token verification
    serverClientId: '269285054406-mehvd44e88dfk6tbl69rou5g920r3lq1.apps.googleusercontent.com',
  );

  GoogleSignInAccount? _currentUser;
  String? _idToken;

  GoogleSignInAccount? get currentUser => _currentUser;
  String? get idToken => _idToken;
  String? get userEmail => _currentUser?.email;
  bool get isSignedIn => _currentUser != null;

  Future<void> init() async {
    try {
      _currentUser = await _googleSignIn.signInSilently();
      if (_currentUser != null) {
        await _refreshToken();
      }
    } catch (e) {
      // Ignore - user will need to sign in manually
    }
  }

  Future<bool> signIn() async {
    try {
      _currentUser = await _googleSignIn.signIn();
      if (_currentUser != null) {
        await _refreshToken();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    _currentUser = null;
    _idToken = null;
  }

  Future<void> _refreshToken() async {
    try {
      final auth = await _currentUser?.authentication;
      _idToken = auth?.idToken;
    } catch (e) {
      // Token refresh failed
    }
  }

  Future<String?> getValidToken() async {
    if (_currentUser == null) return null;
    await _refreshToken();
    return _idToken;
  }

  Map<String, String> getAuthHeaders() {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (_idToken != null) {
      headers['Authorization'] = 'Bearer $_idToken';
    }

    // Always include email header for backwards compatibility
    if (_currentUser?.email != null) {
      headers['X-User-Email'] = _currentUser!.email;
    }

    return headers;
  }

  /// Get auth headers with fresh token (async version)
  Future<Map<String, String>> getAuthHeadersAsync() async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    // Refresh token before returning
    final token = await getValidToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    // Always include email header for backwards compatibility
    if (_currentUser?.email != null) {
      headers['X-User-Email'] = _currentUser!.email;
    }

    return headers;
  }
}
