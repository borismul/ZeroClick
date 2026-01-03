// API service - matching web frontend patterns (frontend/app/page.tsx)

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

  Future<List<Trip>> getTrips({int page = 1, int limit = 50}) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/trips?page=$page&limit=$limit'),
      headers: await _getHeaders(),
    );
    final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
    return data.map((e) => Trip.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Stats> getStats() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/stats'),
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

  // ============ Car Endpoints ============

  Future<CarData> getCarData() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/car/data'),
      headers: await _getHeaders(),
    );
    return CarData.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  /// Get car data for a specific car by ID
  Future<CarData?> getCarDataById(String carId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/cars/$carId/data'),
      headers: await _getHeaders(),
    );
    if (response.statusCode == 400) {
      // Car has no API credentials configured
      return null;
    }
    if (response.statusCode >= 400) {
      throw Exception('Failed to fetch car data');
    }
    return CarData.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<void> saveCarSettings({
    required String brand,
    required String username,
    String? password,
    required String country,
  }) async {
    final body = <String, dynamic>{
      'brand': brand,
      'username': username,
      'country': country,
    };
    if (password != null && password.isNotEmpty) {
      body['password'] = password;
    }

    final response = await http.put(
      Uri.parse('$_baseUrl/settings/car'),
      headers: await _getHeaders(),
      body: jsonEncode(body),
    );

    if (response.statusCode >= 400) {
      throw Exception('Fout bij opslaan: ${response.statusCode}');
    }
  }

  /// Test car API credentials directly - returns error message if failed
  Future<Map<String, dynamic>> testCarApi({
    required String brand,
    required String username,
    required String password,
    required String country,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/car/test'),
      headers: await _getHeaders(),
      body: jsonEncode({
        'brand': brand,
        'username': username,
        'password': password,
        'country': country,
      }),
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode >= 400) {
      throw Exception(data['detail'] ?? data['error'] ?? 'API test mislukt');
    }

    // Check status field
    final status = data['status'] as String?;
    if (status == 'failed') {
      throw Exception(data['error'] ?? 'Login mislukt');
    }
    if (status == 'error') {
      throw Exception(data['error'] ?? 'API fout');
    }

    return data;
  }

  // ============ Multi-Car Management Endpoints ============

  /// Get all cars for the user
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

  /// Create a new car
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

  /// Get a single car
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

  /// Update a car
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

  /// Delete a car
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

  /// Save car API credentials
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

  /// Test car API credentials
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

  /// Get Tesla OAuth authorization URL
  Future<String?> getTeslaAuthUrl(String carId) async {
    // Use a placeholder callback URL - Tesla will redirect here after login
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

  /// Complete Tesla OAuth authorization
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

  /// Get car statistics
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

  /// Get stats filtered by car
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

  /// Get trips filtered by car
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
}
