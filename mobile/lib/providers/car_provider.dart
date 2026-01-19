// Car management provider - extracted from AppProvider

import 'package:flutter/foundation.dart';

import '../core/logging/app_logger.dart';
import '../models/car.dart';
import '../models/trip.dart';
import '../services/api_service.dart';

/// Provider for car management, credentials, and OAuth flows.
///
/// Manages:
/// - Car list and selection state
/// - Car CRUD operations
/// - Car API credentials (username/password for BMW, Mercedes, etc.)
/// - OAuth flows for Tesla, Audi, VW Group, Renault
class CarProvider extends ChangeNotifier {
  CarProvider(this._api);

  static const _log = AppLogger('CarProvider');

  // API service (shared with AppProvider)
  final ApiService _api;

  // ============ Car State ============

  List<Car> _cars = [];
  Car? _selectedCar;
  String? _selectedCarId;
  bool _isLoadingCars = true;
  bool _isLoadingCarData = true;
  CarData? _carData;

  // ============ Getters ============

  List<Car> get cars => _cars;
  Car? get selectedCar => _selectedCar;
  String? get selectedCarId => _selectedCarId;
  bool get isLoadingCars => _isLoadingCars;
  bool get isLoadingCarData => _isLoadingCarData;
  CarData? get carData => _carData;

  /// Returns the default car, or the first car if no default is set.
  Car? get defaultCar =>
      _cars.isEmpty ? null : _cars.firstWhere((c) => c.isDefault, orElse: () => _cars.first);

  // ============ Car CRUD Operations ============

  /// Refresh the cars list from the API.
  /// Auto-selects the default car if none is selected.
  Future<void> refreshCars() async {
    _isLoadingCars = true;
    notifyListeners();

    try {
      _cars = await _api.getCars();

      // Auto-select default car if none selected
      if (_selectedCarId == null && _cars.isNotEmpty) {
        final car = _cars.firstWhere(
          (c) => c.isDefault,
          orElse: () => _cars.first,
        );
        _selectedCar = car;
        _selectedCarId = car.id;
      }
    } on Exception catch (e) {
      _log.error('Error refreshing cars', e);
    }

    _isLoadingCars = false;
    notifyListeners();
  }

  /// Select a car and refresh its data.
  void selectCar(Car car) {
    _selectedCar = car;
    _selectedCarId = car.id;
    notifyListeners();
    // Refresh car data for selected car
    refreshCarData();
  }

  /// Create a new car.
  Future<Car> createCar({
    required String name,
    String brand = 'other',
    String color = '#3B82F6',
    String icon = 'car',
  }) async {
    final car = await _api.createCar(
      name: name,
      brand: brand,
      color: color,
      icon: icon,
    );
    await refreshCars();
    return car;
  }

  /// Update an existing car.
  Future<void> updateCar(
    String carId, {
    String? name,
    String? brand,
    String? color,
    String? icon,
    bool? isDefault,
    String? carplayDeviceId,
  }) async {
    await _api.updateCar(
      carId,
      name: name,
      brand: brand,
      color: color,
      icon: icon,
      isDefault: isDefault,
      carplayDeviceId: carplayDeviceId,
    );
    await refreshCars();
  }

  /// Delete a car.
  Future<void> deleteCar(String carId) async {
    await _api.deleteCar(carId);
    // If deleted car was selected, clear selection
    if (_selectedCarId == carId) {
      _selectedCar = null;
      _selectedCarId = null;
    }
    await refreshCars();
  }

  /// Refresh car data (odometer, battery, etc.) for the selected car.
  Future<void> refreshCarData() async {
    _isLoadingCarData = true;
    notifyListeners();

    try {
      var carId = _selectedCarId;
      if (carId == null || carId.isEmpty) {
        carId = _cars.isNotEmpty ? _cars.first.id : null;
      }
      if (carId != null && carId.isNotEmpty) {
        _carData = await _api.getCarDataById(carId);
      } else {
        _carData = null;
      }
    } on Exception catch (e) {
      _log.error('Error refreshing car data', e);
      _carData = null;
    }

    _isLoadingCarData = false;
    notifyListeners();
  }

  // ============ Car Credentials ============

  /// Save car API credentials.
  Future<void> saveCarCredentials(String carId, CarCredentials creds) async {
    await _api.saveCarCredentials(carId, creds);
    await refreshCars();
  }

  /// Get car API credentials.
  Future<Map<String, dynamic>?> getCarCredentials(String carId) =>
      _api.getCarCredentials(carId);

  /// Delete car API credentials.
  Future<void> deleteCarCredentials(String carId) async {
    await _api.deleteCarCredentials(carId);
    await refreshCars();
  }

  /// Test car API credentials.
  Future<Map<String, dynamic>> testCarCredentials(String carId, CarCredentials creds) =>
      _api.testCarCredentials(carId, creds);

  // ============ Tesla OAuth ============

  /// Get Tesla OAuth URL.
  Future<String?> getTeslaAuthUrl(String carId) => _api.getTeslaAuthUrl(carId);

  /// Complete Tesla OAuth flow.
  Future<bool> completeTeslaAuth(String carId, String callbackUrl) async {
    final success = await _api.completeTeslaAuth(carId, callbackUrl);
    // Don't refresh cars here - let the screen show success state first
    return success;
  }

  // ============ Audi OAuth ============

  /// Get Audi OAuth URL.
  Future<String?> getAudiAuthUrl(String carId) => _api.getAudiAuthUrl(carId);

  /// Complete Audi OAuth flow.
  Future<Map<String, dynamic>> completeAudiAuth(String carId, String redirectUrl) =>
      _api.completeAudiAuth(carId, redirectUrl);

  // ============ VW Group OAuth (Volkswagen, Skoda, SEAT, CUPRA) ============

  /// Get VW Group OAuth URL.
  Future<Map<String, dynamic>> getVWGroupAuthUrl(String carId, String brand) =>
      _api.getVWGroupAuthUrl(carId, brand);

  /// Complete VW Group OAuth flow.
  Future<Map<String, dynamic>> completeVWGroupAuth(
    String carId,
    String brand,
    String redirectUrl,
  ) =>
      _api.completeVWGroupAuth(carId, brand, redirectUrl);

  // ============ Renault OAuth (Gigya-based) ============

  /// Renault direct login via Gigya API.
  Future<Map<String, dynamic>> renaultDirectLogin(
    String carId,
    String username,
    String password, {
    String locale = 'nl_NL',
  }) =>
      _api.renaultDirectLogin(carId, username, password, locale: locale);

  /// Get Renault OAuth URL.
  Future<Map<String, dynamic>> getRenaultAuthUrl(String carId, {String locale = 'nl/nl'}) =>
      _api.getRenaultAuthUrl(carId, locale: locale);

  /// Complete Renault OAuth flow.
  Future<Map<String, dynamic>> completeRenaultAuth(
    String carId,
    String gigyaToken, {
    String? personId,
  }) =>
      _api.completeRenaultAuth(carId, gigyaToken, personId: personId);

  // ============ Helper Methods ============

  /// Find a car by its Bluetooth/CarPlay device ID.
  Car? findCarByDeviceId(String deviceId) {
    for (final car in _cars) {
      if (car.carplayDeviceId != null &&
          car.carplayDeviceId!.toLowerCase() == deviceId.toLowerCase()) {
        return car;
      }
    }
    return null;
  }
}
