// Typed API exceptions for proper error handling

/// Base class for all API exceptions
sealed class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode, this.details});

  final String message;
  final int? statusCode;
  final Map<String, dynamic>? details;

  @override
  String toString() => 'ApiException: $message (status: $statusCode)';
}

/// Network-level errors (no connection, timeout, DNS failure)
final class NetworkException extends ApiException {
  const NetworkException(super.message, {super.statusCode, super.details});

  @override
  String toString() => 'NetworkException: $message';
}

/// 401 Unauthorized - token expired or invalid
final class UnauthorizedException extends ApiException {
  const UnauthorizedException(super.message, {super.statusCode = 401, super.details});

  @override
  String toString() => 'UnauthorizedException: $message';
}

/// 403 Forbidden - user doesn't have permission
final class ForbiddenException extends ApiException {
  const ForbiddenException(super.message, {super.statusCode = 403, super.details});

  @override
  String toString() => 'ForbiddenException: $message';
}

/// 404 Not Found
final class NotFoundException extends ApiException {
  const NotFoundException(super.message, {super.statusCode = 404, super.details});

  @override
  String toString() => 'NotFoundException: $message';
}

/// 400/422 Validation errors
final class ValidationException extends ApiException {
  const ValidationException(
    super.message, {
    super.statusCode = 400,
    super.details,
    this.fieldErrors,
  });

  final Map<String, String>? fieldErrors;

  @override
  String toString() => 'ValidationException: $message, fields: $fieldErrors';
}

/// 5xx Server errors
final class ServerException extends ApiException {
  const ServerException(super.message, {super.statusCode = 500, super.details});

  @override
  String toString() => 'ServerException: $message (status: $statusCode)';
}

/// Request timeout
final class TimeoutException extends ApiException {
  const TimeoutException(super.message, {super.statusCode, super.details});

  @override
  String toString() => 'TimeoutException: $message';
}

/// Request was cancelled
final class CancelledException extends ApiException {
  const CancelledException(super.message, {super.statusCode, super.details});

  @override
  String toString() => 'CancelledException: $message';
}

/// Unknown/generic API error
final class UnknownApiException extends ApiException {
  const UnknownApiException(super.message, {super.statusCode, super.details});

  @override
  String toString() => 'UnknownApiException: $message (status: $statusCode)';
}
