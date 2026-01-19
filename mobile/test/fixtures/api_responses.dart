/// API response fixtures for testing webhook flows.
///
/// Contains factory methods for all webhook response scenarios including
/// normal operation, edge cases, and error conditions.
class ApiResponses {
  // === Ping Responses ===

  /// Normal driving response - car detected and actively driving
  static Map<String, dynamic> drivingResponse({
    String carId = 'car-123',
    String carName = 'Audi A4',
    double distanceKm = 5.0,
    int parkedCount = 0,
  }) =>
      {
        'status': 'driving',
        'car_id': carId,
        'car_name': carName,
        'distance_km': distanceKm,
        'parked_count': parkedCount,
        'no_driving_count': 0,
        'api_error_count': 0,
      };

  /// Parked response (car API reports parked)
  static Map<String, dynamic> parkedResponse({
    int parkedCount = 1,
    double distanceKm = 10.0,
  }) =>
      {
        'status': 'parked',
        'parked_count': parkedCount,
        'distance_km': distanceKm,
        'no_driving_count': 0,
        'api_error_count': 0,
      };

  /// No car driving found response
  static Map<String, dynamic> noCarDrivingResponse({
    int noDrivingCount = 1,
  }) =>
      {
        'status': 'no_car_driving',
        'no_driving_count': noDrivingCount,
        'parked_count': 0,
        'api_error_count': 0,
      };

  /// API error response (car API failed)
  static Map<String, dynamic> apiErrorResponse({
    int apiErrorCount = 1,
  }) =>
      {
        'status': 'api_error',
        'api_error_count': apiErrorCount,
        'no_driving_count': 0,
        'parked_count': 0,
      };

  /// GPS-only mode active - no car API, using phone GPS for tracking
  static Map<String, dynamic> gpsOnlyResponse({
    double distanceKm = 5.0,
  }) =>
      {
        'status': 'gps_only',
        'gps_only_mode': true,
        'distance_km': distanceKm,
      };

  /// At skip location (paused) - e.g., at gas station or coffee shop
  static Map<String, dynamic> skipLocationResponse({
    int skipPauseCount = 1,
  }) =>
      {
        'status': 'skip_paused',
        'skip_pause_count': skipPauseCount,
        'at_skip_location': true,
      };

  /// Unknown state response (edge case)
  static Map<String, dynamic> unknownStateResponse() => {
        'status': 'unknown',
      };

  // === Start/End Responses ===

  /// Trip started successfully
  static Map<String, dynamic> tripStartedResponse({
    String tripId = 'trip-abc123',
  }) =>
      {
        'status': 'started',
        'trip_id': tripId,
      };

  /// Trip finalized successfully
  static Map<String, dynamic> tripFinalizedResponse({
    String tripId = 'trip-abc123',
    double totalKm = 15.5,
  }) =>
      {
        'status': 'finalized',
        'trip_id': tripId,
        'total_km': totalKm,
      };

  /// Trip cancelled (e.g., no car found after retries)
  static Map<String, dynamic> tripCancelledResponse() => {
        'status': 'cancelled',
      };

  /// Already active trip exists
  static Map<String, dynamic> tripAlreadyActiveResponse({
    String tripId = 'trip-existing',
  }) =>
      {
        'status': 'already_active',
        'trip_id': tripId,
      };

  // === Status Responses ===

  /// Active trip status
  static Map<String, dynamic> activeTripStatus({
    String tripId = 'trip-abc123',
    String carId = 'car-123',
    double distanceKm = 10.5,
    int pingCount = 5,
  }) =>
      {
        'active': true,
        'trip_id': tripId,
        'car_id': carId,
        'distance_km': distanceKm,
        'ping_count': pingCount,
      };

  /// No active trip
  static Map<String, dynamic> noActiveTripStatus() => {
        'active': false,
      };

  // === Error Responses (for simulating failures) ===

  /// Simulates 502 Bad Gateway
  static Exception serverError502() => Exception('502 Bad Gateway');

  /// Simulates 503 Service Unavailable
  static Exception serverError503() => Exception('503 Service Unavailable');

  /// Simulates network timeout
  static Exception networkTimeout() => Exception('Connection timed out');

  /// Simulates 401 Unauthorized (token expired)
  static Exception unauthorized() => Exception('401 Unauthorized');

  /// Simulates 429 Too Many Requests (rate limited)
  static Exception rateLimited() => Exception('429 Too Many Requests');
}
