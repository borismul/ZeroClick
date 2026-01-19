import '../core/api/api_client.dart';
import '../core/api/api_exception.dart';
import '../core/logging/app_logger.dart';
import '../models/car.dart';
import '../models/location.dart';
import '../models/trip.dart';

/// API service for all backend communication
class ApiService {
  ApiService({
    required String baseUrl,
    required String userEmail,
  })  : _client = ApiClient(baseUrl: baseUrl),
        _userEmail = userEmail {
    _client.setUserEmail(userEmail);
  }

  final ApiClient _client;
  final _log = const AppLogger('ApiService');
  String _userEmail;

  /// Update configuration
  void updateConfig(String baseUrl, String userEmail) {
    _client.updateConfig(baseUrl: baseUrl, userEmail: userEmail);
    _userEmail = userEmail;
  }

  /// Set auth token
  void setAuthToken(String? token) {
    _client.setAuthToken(token);
  }

  /// Set token refresh callback (called on 401 to get a fresh token)
  void setTokenRefreshCallback(TokenRefreshCallback? callback) {
    _client.setTokenRefreshCallback(callback);
  }

  // ============ Webhook Endpoints ============

  Future<Map<String, dynamic>> startTrip(double lat, double lng, {String? deviceId}) async {
    final queryParams = <String, String>{
      'user': _userEmail,
    };
    if (deviceId != null) {
      queryParams['device_id'] = deviceId;
    }

    _log.info('Starting trip at $lat, $lng');
    return _client.post<Map<String, dynamic>>(
      '/webhook/start',
      queryParams: queryParams,
      body: {'lat': lat, 'lng': lng},
    );
  }

  Future<Map<String, dynamic>> endTrip(double lat, double lng) async {
    _log.info('Ending trip at $lat, $lng');
    return _client.post<Map<String, dynamic>>(
      '/webhook/end',
      queryParams: {'user': _userEmail},
      body: {'lat': lat, 'lng': lng},
    );
  }

  Future<Map<String, dynamic>> sendPing(double lat, double lng, {String? deviceId}) async {
    final queryParams = <String, String>{
      'user': _userEmail,
    };
    if (deviceId != null) {
      queryParams['device_id'] = deviceId;
    }

    return _client.post<Map<String, dynamic>>(
      '/webhook/ping',
      queryParams: queryParams,
      body: {'lat': lat, 'lng': lng},
    );
  }

  Future<ActiveTrip> getStatus() async => _client.get<ActiveTrip>(
        '/webhook/status',
        fromJson: (json) => ActiveTrip.fromJson(json as Map<String, dynamic>),
      );

  Future<Map<String, dynamic>> finalize() async {
    _log.info('Finalizing trip');
    return _client.post<Map<String, dynamic>>(
      '/webhook/finalize',
      queryParams: {'user': _userEmail},
    );
  }

  Future<Map<String, dynamic>> cancel() async {
    _log.info('Canceling trip');
    return _client.post<Map<String, dynamic>>(
      '/webhook/cancel',
      queryParams: {'user': _userEmail},
    );
  }

  // ============ Trip Endpoints ============

  Future<List<Trip>> getTripsForCar(String? carId, {int page = 1, int limit = 50}) async {
    final queryParams = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };
    if (carId != null) {
      queryParams['car_id'] = carId;
    }

    return _client.get<List<Trip>>(
      '/trips',
      queryParams: queryParams,
      fromJson: (json) => (json as List<dynamic>)
          .map((e) => Trip.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<Stats> getStatsForCar(String? carId) async {
    final queryParams = <String, String>{};
    if (carId != null) {
      queryParams['car_id'] = carId;
    }

    return _client.get<Stats>(
      '/stats',
      queryParams: queryParams,
      fromJson: (json) => Stats.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<Trip> updateTrip(String tripId, Map<String, dynamic> updates) async =>
      _client.patch<Trip>(
        '/trips/$tripId',
        body: updates,
        fromJson: (json) => Trip.fromJson(json as Map<String, dynamic>),
      );

  Future<void> deleteTrip(String tripId) async {
    await _client.delete<Map<String, dynamic>>('/trips/$tripId');
  }

  Future<Trip> createTrip(Map<String, dynamic> tripData) async => _client.post<Trip>(
        '/trips',
        body: tripData,
        fromJson: (json) => Trip.fromJson(json as Map<String, dynamic>),
      );

  // ============ Location Endpoints ============

  Future<List<UserLocation>> getLocations() async => _client.get<List<UserLocation>>(
        '/locations',
        fromJson: (json) => (json as List<dynamic>)
            .map((e) => UserLocation.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Future<Map<String, dynamic>> addLocation({
    required String name,
    required double lat,
    required double lng,
  }) async {
    _log.info('Adding location: $name at $lat, $lng');
    return _client.post<Map<String, dynamic>>(
      '/locations',
      body: {'name': name, 'lat': lat, 'lng': lng},
    );
  }

  // ============ Car Management Endpoints ============

  Future<List<Car>> getCars() async => _client.get<List<Car>>(
        '/cars',
        fromJson: (json) => (json as List<dynamic>)
            .map((e) => Car.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Future<Car> createCar({
    required String name,
    String brand = 'other',
    String color = '#3B82F6',
    String icon = 'car',
  }) async =>
      _client.post<Car>(
        '/cars',
        body: {
          'name': name,
          'brand': brand,
          'color': color,
          'icon': icon,
        },
        fromJson: (json) => Car.fromJson(json as Map<String, dynamic>),
      );

  Future<Car> getCar(String carId) async => _client.get<Car>(
        '/cars/$carId',
        fromJson: (json) => Car.fromJson(json as Map<String, dynamic>),
      );

  Future<void> updateCar(
    String carId, {
    String? name,
    String? brand,
    String? color,
    String? icon,
    bool? isDefault,
    String? carplayDeviceId,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (brand != null) body['brand'] = brand;
    if (color != null) body['color'] = color;
    if (icon != null) body['icon'] = icon;
    if (isDefault != null) body['is_default'] = isDefault;
    if (carplayDeviceId != null) body['carplay_device_id'] = carplayDeviceId;

    await _client.patch<Map<String, dynamic>>('/cars/$carId', body: body);
  }

  Future<void> deleteCar(String carId) async {
    try {
      await _client.delete<Map<String, dynamic>>('/cars/$carId');
    } on ValidationException catch (e) {
      throw Exception(e.details?['detail'] ?? 'Kan auto niet verwijderen');
    }
  }

  Future<CarData?> getCarDataById(String carId) async {
    try {
      return await _client.get<CarData>(
        '/cars/$carId/data',
        fromJson: (json) => CarData.fromJson(json as Map<String, dynamic>),
      );
    } on ValidationException {
      return null;
    } on NotFoundException {
      return null;
    }
  }

  Future<void> saveCarCredentials(String carId, CarCredentials creds) async {
    await _client.put<Map<String, dynamic>>(
      '/cars/$carId/credentials',
      body: creds.toJson(),
    );
  }

  Future<Map<String, dynamic>?> getCarCredentials(String carId) async {
    try {
      return await _client.get<Map<String, dynamic>>('/cars/$carId/credentials');
    } on NotFoundException {
      return null;
    }
  }

  Future<void> deleteCarCredentials(String carId) async {
    await _client.delete<Map<String, dynamic>>('/cars/$carId/credentials');
  }

  Future<Map<String, dynamic>> testCarCredentials(String carId, CarCredentials creds) async =>
      _client.post<Map<String, dynamic>>(
        '/cars/$carId/credentials/test',
        body: creds.toJson(),
      );

  Future<String?> getTeslaAuthUrl(String carId) async {
    const callbackUrl = 'https://auth.tesla.com/void/callback';
    final result = await _client.get<Map<String, dynamic>>(
      '/cars/$carId/tesla/auth-url',
      queryParams: {'callback_url': callbackUrl},
    );

    if (result['status'] == 'already_authorized') {
      return null;
    }

    return result['auth_url'] as String?;
  }

  Future<bool> completeTeslaAuth(String carId, String callbackUrl) async {
    await _client.post<Map<String, dynamic>>(
      '/cars/$carId/tesla/callback',
      queryParams: {'callback_url': callbackUrl},
    );
    return true;
  }

  // Audi OAuth methods
  Future<String?> getAudiAuthUrl(String carId) async {
    final result = await _client.post<Map<String, dynamic>>(
      '/audi/auth/url',
      body: {'car_id': carId},
    );
    return result['auth_url'] as String?;
  }

  Future<Map<String, dynamic>> completeAudiAuth(String carId, String redirectUrl) async =>
      _client.post<Map<String, dynamic>>(
        '/audi/auth/callback',
        body: {
          'car_id': carId,
          'redirect_url': redirectUrl,
        },
      );

  // VW Group OAuth methods (Volkswagen, Skoda, SEAT, CUPRA)
  Future<Map<String, dynamic>> getVWGroupAuthUrl(String carId, String brand) async =>
      _client.post<Map<String, dynamic>>(
        '/vwgroup/auth/url',
        body: {
          'car_id': carId,
          'brand': brand,
        },
      );

  Future<Map<String, dynamic>> completeVWGroupAuth(String carId, String brand, String redirectUrl) async =>
      _client.post<Map<String, dynamic>>(
        '/vwgroup/auth/callback',
        body: {
          'car_id': carId,
          'brand': brand,
          'redirect_url': redirectUrl,
        },
      );

  // Renault OAuth methods (Gigya-based)
  Future<Map<String, dynamic>> renaultDirectLogin(
    String carId,
    String username,
    String password, {
    String locale = 'nl_NL',
  }) async =>
      _client.post<Map<String, dynamic>>(
        '/renault/auth/login',
        body: {
          'car_id': carId,
          'username': username,
          'password': password,
          'locale': locale,
        },
      );

  Future<Map<String, dynamic>> getRenaultAuthUrl(String carId, {String locale = 'nl/nl'}) async =>
      _client.post<Map<String, dynamic>>(
        '/renault/auth/url',
        body: {
          'car_id': carId,
          'locale': locale,
        },
      );

  Future<Map<String, dynamic>> completeRenaultAuth(String carId, String gigyaToken, {String? personId}) async =>
      _client.post<Map<String, dynamic>>(
        '/renault/auth/callback',
        body: {
          'car_id': carId,
          'gigya_token': gigyaToken,
          if (personId != null) 'gigya_person_id': personId,
        },
      );

  Future<CarStats> getCarStats(String carId) async => _client.get<CarStats>(
        '/cars/$carId/stats',
        fromJson: (json) => CarStats.fromJson(json as Map<String, dynamic>),
      );

  // ============ Account Management ============

  /// Delete the current user's account and all associated data.
  /// This is permanent and cannot be undone.
  Future<void> deleteAccount() async {
    _log.info('Deleting account');
    await _client.delete<Map<String, dynamic>>('/account');
  }
}
