import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../logging/app_logger.dart';
import 'api_exception.dart';

/// Callback type for token refresh - returns new token or null if refresh failed
typedef TokenRefreshCallback = Future<String?> Function();

/// HTTP client with proper error handling, retry logic, and timeout configuration
class ApiClient {
  ApiClient({
    required String baseUrl,
    Duration? timeout,
    int? maxRetries,
    TokenRefreshCallback? onTokenRefresh,
  })  : _baseUrl = baseUrl,
        _timeout = timeout ?? const Duration(seconds: 30),
        _maxRetries = maxRetries ?? 3,
        _onTokenRefresh = onTokenRefresh;

  String _baseUrl;
  final Duration _timeout;
  final int _maxRetries;
  final _log = const AppLogger('ApiClient');
  TokenRefreshCallback? _onTokenRefresh;

  String? _authToken;
  String? _userEmail;

  /// Update base configuration
  void updateConfig({String? baseUrl, String? authToken, String? userEmail}) {
    if (baseUrl != null) _baseUrl = baseUrl;
    if (authToken != null) _authToken = authToken;
    if (userEmail != null) _userEmail = userEmail;
  }

  /// Set auth token
  void setAuthToken(String? token) {
    _authToken = token;
  }

  /// Set user email
  void setUserEmail(String? email) {
    _userEmail = email;
  }

  /// Set token refresh callback
  void setTokenRefreshCallback(TokenRefreshCallback? callback) {
    _onTokenRefresh = callback;
  }

  /// Get default headers
  Map<String, String> get _headers {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }

    if (_userEmail != null) {
      headers['X-User-Email'] = _userEmail!;
    }

    return headers;
  }

  /// Build full URL from path
  Uri _buildUri(String path, {Map<String, String>? queryParams}) {
    final uri = Uri.parse('$_baseUrl$path');
    if (queryParams != null && queryParams.isNotEmpty) {
      return uri.replace(queryParameters: {...uri.queryParameters, ...queryParams});
    }
    return uri;
  }

  /// Execute GET request
  Future<T> get<T>(
    String path, {
    Map<String, String>? queryParams,
    Map<String, String>? headers,
    T Function(dynamic json)? fromJson,
  }) async =>
      _executeWithRetry(
        () => http.get(
          _buildUri(path, queryParams: queryParams),
          headers: {..._headers, ...?headers},
        ),
        fromJson: fromJson,
        method: 'GET',
        path: path,
      );

  /// Execute POST request
  Future<T> post<T>(
    String path, {
    Object? body,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
    T Function(dynamic json)? fromJson,
  }) async =>
      _executeWithRetry(
        () => http.post(
          _buildUri(path, queryParams: queryParams),
          headers: {..._headers, ...?headers},
          body: body != null ? jsonEncode(body) : null,
        ),
        fromJson: fromJson,
        method: 'POST',
        path: path,
      );

  /// Execute PATCH request
  Future<T> patch<T>(
    String path, {
    Object? body,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
    T Function(dynamic json)? fromJson,
  }) async =>
      _executeWithRetry(
        () => http.patch(
          _buildUri(path, queryParams: queryParams),
          headers: {..._headers, ...?headers},
          body: body != null ? jsonEncode(body) : null,
        ),
        fromJson: fromJson,
        method: 'PATCH',
        path: path,
      );

  /// Execute PUT request
  Future<T> put<T>(
    String path, {
    Object? body,
    Map<String, String>? queryParams,
    Map<String, String>? headers,
    T Function(dynamic json)? fromJson,
  }) async =>
      _executeWithRetry(
        () => http.put(
          _buildUri(path, queryParams: queryParams),
          headers: {..._headers, ...?headers},
          body: body != null ? jsonEncode(body) : null,
        ),
        fromJson: fromJson,
        method: 'PUT',
        path: path,
      );

  /// Execute DELETE request
  Future<T> delete<T>(
    String path, {
    Map<String, String>? queryParams,
    Map<String, String>? headers,
    T Function(dynamic json)? fromJson,
  }) async =>
      _executeWithRetry(
        () => http.delete(
          _buildUri(path, queryParams: queryParams),
          headers: {..._headers, ...?headers},
        ),
        fromJson: fromJson,
        method: 'DELETE',
        path: path,
      );

  /// Execute request with retry logic
  Future<T> _executeWithRetry<T>(
    Future<http.Response> Function() request, {
    required String method,
    required String path,
    T Function(dynamic json)? fromJson,
    bool isRetryAfterRefresh = false,
  }) async {
    var attempts = 0;
    ApiException? lastException;

    while (attempts < _maxRetries) {
      attempts++;
      try {
        final response = await request().timeout(_timeout);
        return _handleResponse(response, fromJson: fromJson);
      } on SocketException catch (e) {
        _log.warning('Network error on $method $path (attempt $attempts): $e');
        lastException = NetworkException('Geen internetverbinding', details: {'error': e.toString()});
      } on TimeoutException catch (e) {
        _log.warning('Timeout on $method $path (attempt $attempts): $e');
        lastException = const TimeoutException('Request timeout');
      } on http.ClientException catch (e) {
        _log.warning('HTTP client error on $method $path (attempt $attempts): $e');
        lastException = NetworkException('Verbindingsfout', details: {'error': e.toString()});
      } on UnauthorizedException {
        // 401 Unauthorized - try to refresh token and retry once
        if (!isRetryAfterRefresh && _onTokenRefresh != null) {
          _log.info('Got 401, attempting token refresh...');
          final newToken = await _onTokenRefresh!();
          if (newToken != null) {
            _log.info('Token refreshed, retrying request...');
            _authToken = newToken;
            // Retry with new token (mark as retry to prevent infinite loop)
            return _executeWithRetry(
              request,
              method: method,
              path: path,
              fromJson: fromJson,
              isRetryAfterRefresh: true,
            );
          }
          _log.warning('Token refresh failed, giving up');
        }
        // No refresh callback or refresh failed - propagate the error
        rethrow;
      } on ApiException catch (e) {
        // Don't retry other client errors (4xx except 401 which is handled above)
        if (e.statusCode != null && e.statusCode! >= 400 && e.statusCode! < 500) {
          rethrow;
        }
        _log.warning('API error on $method $path (attempt $attempts): $e');
        lastException = e;
      }

      // Exponential backoff before retry
      if (attempts < _maxRetries) {
        final delay = Duration(milliseconds: 100 * (1 << attempts));
        _log.debug('Retrying in ${delay.inMilliseconds}ms...');
        await Future<void>.delayed(delay);
      }
    }

    _log.error('All $attempts attempts failed for $method $path');
    throw lastException ?? const NetworkException('Onbekende fout');
  }

  /// Handle HTTP response and convert to typed result or exception
  T _handleResponse<T>(
    http.Response response, {
    T Function(dynamic json)? fromJson,
  }) {
    final statusCode = response.statusCode;
    _log.debug('Response $statusCode: ${response.body.length} bytes');

    // Parse response body
    dynamic body;
    try {
      if (response.body.isNotEmpty) {
        body = jsonDecode(response.body);
      }
    } on FormatException {
      body = response.body;
    }

    // Success responses
    if (statusCode >= 200 && statusCode < 300) {
      if (fromJson != null) {
        return fromJson(body);
      }
      return body as T;
    }

    // Extract error message from response
    final message = _extractErrorMessage(body);

    // Map status codes to exceptions
    switch (statusCode) {
      case 400:
      case 422:
        throw ValidationException(
          message,
          statusCode: statusCode,
          details: body is Map<String, dynamic> ? body : null,
        );
      case 401:
        throw UnauthorizedException(message, statusCode: statusCode);
      case 403:
        throw ForbiddenException(message, statusCode: statusCode);
      case 404:
        throw NotFoundException(message, statusCode: statusCode);
      case >= 500:
        throw ServerException(message, statusCode: statusCode);
      default:
        throw UnknownApiException(message, statusCode: statusCode);
    }
  }

  /// Extract error message from response body
  String _extractErrorMessage(dynamic body) {
    if (body is Map<String, dynamic>) {
      // FastAPI error format
      if (body.containsKey('detail')) {
        final detail = body['detail'];
        if (detail is String) return detail;
        if (detail is List && detail.isNotEmpty) {
          final first = detail.first;
          if (first is Map<String, dynamic>) {
            return first['msg']?.toString() ?? 'Validatiefout';
          }
        }
      }
      // Generic error format
      if (body.containsKey('message')) {
        return body['message'] as String;
      }
      if (body.containsKey('error')) {
        return body['error'] as String;
      }
    }
    if (body is String && body.isNotEmpty) {
      return body;
    }
    return 'Er is een fout opgetreden';
  }
}
