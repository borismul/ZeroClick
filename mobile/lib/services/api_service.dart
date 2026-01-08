// API service - matching web frontend patterns

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/trip.dart';
import '../models/car.dart';
import '../models/location.dart';
import 'auth_service.dart';

class ApiService {
  String _baseUrl;
  String _userEmail;
  final AuthService _auth = AuthService();

  ApiService({
    required String baseUrl,
    required String userEmail,
  })  : _baseUrl = baseUrl,
        _userEmail = userEmail;

  void updateConfig(String baseUrl, String userEmail) {
    _baseUrl = baseUrl;
    _userEmail = userEmail;
  }

  Future<Map<String, String>> _getHeaders() async {
    final authHeaders = await _auth.getAuthHeadersAsync();
    if (!authHeaders.containsKey('X-User-Email') && _userEmail.isNotEmpty) {
      authHeaders['X-User-Email'] = _userEmail;
    }
    return authHeaders;
  }

  // ============ Webhook Endpoints ============

  Future<Map<String, dynamic>> startTrip(double lat, double lng, {String? deviceId}) async {
    var url = '$_baseUrl/webhook/start?user=${Uri.encodeComponent(_userEmail)}';
    if (deviceId != null) {
      url += '&device_id=${Uri.encodeComponent(deviceId)}';
    }
    final response = await http.post(
      Uri.parse(url),
      headers: await _getHeaders(),
      body: jsonEncode({'lat': lat, 'lng': lng}),
    );
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> endTrip(double lat, double lng) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/webhook/end?user=${Uri.encodeComponent(_userEmail)}'),
      headers: await _getHeaders(),
      body: jsonEncode({'lat': lat, 'lng': lng}),
    );
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> sendPing(double lat, double lng, {String? deviceId}) async {
    var url = '$_baseUrl/webhook/ping?user=${Uri.encodeComponent(_userEmail)}';
    if (deviceId != null) {
      url += '&device_id=${Uri.encodeComponent(deviceId)}';
    }
    final response = await http.post(
      Uri.parse(url),
      headers: await _getHeaders(),
      body: jsonEncode({'lat': lat, 'lng': lng}),
    );
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<ActiveTrip> getStatus() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/webhook/status'),
      headers: await _getHeaders(),
    );
    return ActiveTrip.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> finalize() async {
    final response = await http.post(
      Uri.parse('$_baseUrl/webhook/finalize?user=${Uri.encodeComponent(_userEmail)}'),
      headers: await _getHeaders(),
    );
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> cancel() async {
    final response = await http.post(
      Uri.parse('$_baseUrl/webhook/cancel?user=${Uri.encodeComponent(_userEmail)}'),
      headers: await _getHeaders(),
    );
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  // ============ Trip Endpoints ============

  Future<List<Trip>> getTripsForCar(String? carId, {int page = 1, int limit = 50}) async {
    final url = carId != null
        ? '$_baseUrl/trips?page=$page&limit=$limit&car_id=$carId'
        : '$_baseUrl/trips?page=$page&limit=$limit';
    final response = await http.get(
      Uri.parse(url),
      headers: await _getHeaders(),
    );
    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    return data.map((e) => Trip.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Stats> getStatsForCar(String? carId) async {
    final url = carId != null
        ? '$_baseUrl/stats?car_id=$carId'
        : '$_baseUrl/stats';
    final response = await http.get(
      Uri.parse(url),
      headers: await _getHeaders(),
    );
    return Stats.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<Trip> updateTrip(String tripId, Map<String, dynamic> updates) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl/trips/$tripId'),
      headers: await _getHeaders(),
      body: jsonEncode(updates),
    );
    return Trip.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<void> deleteTrip(String tripId) async {
    await http.delete(
      Uri.parse('$_baseUrl/trips/$tripId'),
      headers: await _getHeaders(),
    );
  }

  Future<Trip> createTrip(Map<String, dynamic> tripData) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/trips'),
      headers: await _getHeaders(),
      body: jsonEncode(tripData),
    );
    if (response.statusCode >= 400) {
      throw Exception('Failed to create trip');
    }
    return Trip.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  // ============ Location Endpoints ============

  Future<List<UserLocation>> getLocations() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/locations'),
      headers: await _getHeaders(),
    );
    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    return data.map((e) => UserLocation.fromJson(e as Map<String, dynamic>)).toList();
  }

  // ============ Car Management Endpoints ============

  Future<List<Car>> getCars() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/cars'),
      headers: await _getHeaders(),
    );
    if (response.statusCode >= 400) {
      throw Exception('Failed to fetch cars');
    }
    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    return data.map((e) => Car.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Car> createCar({
    required String name,
    String brand = 'other',
    String color = '#3B82F6',
    String icon = 'car',
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/cars'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'name': name,
        'brand': brand,
        'color': color,
        'icon': icon,
      }),
    );
    if (response.statusCode >= 400) {
      throw Exception('Failed to create car');
    }
    return Car.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<Car> getCar(String carId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/cars/$carId'),
      headers: await _getHeaders(),
    );
    if (response.statusCode >= 400) {
      throw Exception('Car not found');
    }
    return Car.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<void> updateCar(String carId, {
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

    final response = await http.patch(
      Uri.parse('$_baseUrl/cars/$carId'),
      headers: await _getHeaders(),
      body: jsonEncode(body),
    );
    if (response.statusCode >= 400) {
      throw Exception('Failed to update car');
    }
  }

  Future<void> deleteCar(String carId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/cars/$carId'),
      headers: await _getHeaders(),
    );
    if (response.statusCode >= 400) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      throw Exception(data['detail'] ?? 'Failed to delete car');
    }
  }

  Future<CarData?> getCarDataById(String carId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/cars/$carId/data'),
      headers: await _getHeaders(),
    );
    if (response.statusCode == 400) {
      return null;
    }
    if (response.statusCode >= 400) {
      throw Exception('Failed to fetch car data');
    }
    return CarData.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<void> saveCarCredentials(String carId, CarCredentials creds) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/cars/$carId/credentials'),
      headers: await _getHeaders(),
      body: jsonEncode(creds.toJson()),
    );
    if (response.statusCode >= 400) {
      throw Exception('Failed to save credentials');
    }
  }

  Future<Map<String, dynamic>?> getCarCredentials(String carId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/cars/$carId/credentials'),
      headers: await _getHeaders(),
    );
    if (response.statusCode == 404) {
      return null; // No credentials
    }
    if (response.statusCode >= 400) {
      return null;
    }
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<void> deleteCarCredentials(String carId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/cars/$carId/credentials'),
      headers: await _getHeaders(),
    );
    if (response.statusCode >= 400) {
      throw Exception('Failed to delete credentials');
    }
  }

  Future<Map<String, dynamic>> testCarCredentials(String carId, CarCredentials creds) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/cars/$carId/credentials/test'),
      headers: await _getHeaders(),
      body: jsonEncode(creds.toJson()),
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode >= 400) {
      throw Exception(data['detail'] ?? 'Connection failed');
    }
    return data;
  }

  Future<String?> getTeslaAuthUrl(String carId) async {
    const callbackUrl = 'https://auth.tesla.com/void/callback';
    final response = await http.get(
      Uri.parse('$_baseUrl/cars/$carId/tesla/auth-url?callback_url=$callbackUrl'),
      headers: await _getHeaders(),
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode >= 400) {
      throw Exception(data['detail'] ?? 'Failed to get Tesla auth URL');
    }

    if (data['status'] == 'already_authorized') {
      return null;
    }

    return data['auth_url'] as String?;
  }

  Future<bool> completeTeslaAuth(String carId, String callbackUrl) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/cars/$carId/tesla/callback?callback_url=${Uri.encodeComponent(callbackUrl)}'),
      headers: await _getHeaders(),
    );

    if (response.statusCode >= 400) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      throw Exception(data['detail'] ?? 'Tesla authorization failed');
    }

    return true;
  }

  // Audi OAuth methods
  Future<String?> getAudiAuthUrl(String carId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/audi/auth/url'),
      headers: await _getHeaders(),
      body: jsonEncode({'car_id': carId}),
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode >= 400) {
      throw Exception(data['detail'] ?? 'Failed to get Audi auth URL');
    }

    return data['auth_url'] as String?;
  }

  Future<Map<String, dynamic>> completeAudiAuth(String carId, String redirectUrl) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/audi/auth/callback'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'car_id': carId,
        'redirect_url': redirectUrl,
      }),
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode >= 400) {
      throw Exception(data['detail'] ?? 'Audi authorization failed');
    }

    return data;
  }

  // VW Group OAuth methods (Volkswagen, Skoda, SEAT, CUPRA)
  Future<Map<String, dynamic>> getVWGroupAuthUrl(String carId, String brand) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/vwgroup/auth/url'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'car_id': carId,
        'brand': brand,
      }),
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode >= 400) {
      throw Exception(data['detail'] ?? 'Failed to get $brand auth URL');
    }

    return data;
  }

  Future<Map<String, dynamic>> completeVWGroupAuth(String carId, String brand, String redirectUrl) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/vwgroup/auth/callback'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'car_id': carId,
        'brand': brand,
        'redirect_url': redirectUrl,
      }),
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode >= 400) {
      throw Exception(data['detail'] ?? '$brand authorization failed');
    }

    return data;
  }

  // Renault OAuth methods (Gigya-based)
  Future<Map<String, dynamic>> renaultDirectLogin(String carId, String username, String password, {String locale = 'nl_NL'}) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/renault/auth/login'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'car_id': carId,
        'username': username,
        'password': password,
        'locale': locale,
      }),
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode >= 400) {
      throw Exception(data['detail'] ?? 'Renault login failed');
    }

    return data;
  }

  Future<Map<String, dynamic>> getRenaultAuthUrl(String carId, {String locale = 'nl/nl'}) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/renault/auth/url'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'car_id': carId,
        'locale': locale,
      }),
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode >= 400) {
      throw Exception(data['detail'] ?? 'Failed to get Renault auth URL');
    }

    return data;
  }

  Future<Map<String, dynamic>> completeRenaultAuth(String carId, String gigyaToken, {String? personId}) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/renault/auth/callback'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'car_id': carId,
        'gigya_token': gigyaToken,
        if (personId != null) 'gigya_person_id': personId,
      }),
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode >= 400) {
      throw Exception(data['detail'] ?? 'Renault authorization failed');
    }

    return data;
  }

  Future<CarStats> getCarStats(String carId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/cars/$carId/stats'),
      headers: await _getHeaders(),
    );
    if (response.statusCode >= 400) {
      throw Exception('Failed to fetch car stats');
    }
    return CarStats.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }
}
