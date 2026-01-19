import 'package:matcher/matcher.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks/fake_location_service.dart';
import '../mocks/mock_api_service.dart';
import '../mocks/fake_bluetooth_service.dart';
import '../mocks/fake_background_service.dart';
import '../fixtures/api_responses.dart';
import '../fixtures/drive_scenarios.dart';

/// Orchestrates mock services for drive simulation testing.
///
/// Usage:
/// ```dart
/// fakeAsync((async) {
///   final simulator = DriveSimulator();
///   simulator.setupHomeToOfficeTrip();
///   simulator.startTrip();
///
///   for (var i = 0; i < 5; i++) {
///     async.elapse(Duration(minutes: 1));
///     simulator.triggerPing();
///   }
///
///   simulator.endTrip();
///   expect(simulator.wasTripFinalized, isTrue);
/// });
/// ```
class DriveSimulator {
  final FakeLocationService locationService;
  final MockApiService apiService;
  final FakeBluetoothService bluetoothService;
  final FakeBackgroundService backgroundService;

  // Trip state tracking
  bool _tripStarted = false;
  bool _tripFinalized = false;
  bool _tripCancelled = false;
  int _pingCount = 0;
  final List<Map<String, dynamic>> _pingResponses = [];

  DriveSimulator({
    FakeLocationService? location,
    MockApiService? api,
    FakeBluetoothService? bluetooth,
    FakeBackgroundService? background,
  })  : locationService = location ?? FakeLocationService(),
        apiService = api ?? MockApiService(),
        bluetoothService = bluetooth ?? FakeBluetoothService(),
        backgroundService = background ?? FakeBackgroundService();

  // === Setup Methods ===

  /// Configure a simple home-to-office drive scenario
  void setupHomeToOfficeTrip({String? bluetoothDevice}) {
    locationService.scheduleDrive(DriveScenarios.homeToOffice());

    if (bluetoothDevice != null) {
      bluetoothService.simulateConnect(bluetoothDevice);
    }

    _setupDefaultApiResponses();
  }

  /// Configure a trip that visits a skip location
  void setupTripWithSkipLocation({String? bluetoothDevice}) {
    locationService.scheduleDrive(DriveScenarios.tripWithSkipLocation());

    if (bluetoothDevice != null) {
      bluetoothService.simulateConnect(bluetoothDevice);
    }

    _setupDefaultApiResponses();
  }

  /// Configure a stationary trip (should be cancelled)
  void setupStationaryTrip() {
    locationService.scheduleDrive(DriveScenarios.stationaryTrip());
    _setupNoDrivingApiResponses();
  }

  /// Configure API to fail (for GPS-only mode testing)
  void setupApiFailures() {
    when(() => apiService.sendPing(any(), any(), deviceId: any(named: 'deviceId')))
        .thenThrow(ApiResponses.serverError502());
  }

  /// Configure custom API response sequence
  void setupApiResponseSequence(List<Map<String, dynamic>> responses) {
    var index = 0;
    when(() => apiService.sendPing(any(), any(), deviceId: any(named: 'deviceId')))
        .thenAnswer((_) async {
      if (index < responses.length) {
        return responses[index++];
      }
      return ApiResponses.drivingResponse();
    });
  }

  void _setupDefaultApiResponses() {
    // First ping: car identified, driving
    // Subsequent pings: driving with increasing distance
    var pingNum = 0;
    when(() => apiService.sendPing(any(), any(), deviceId: any(named: 'deviceId')))
        .thenAnswer((_) async {
      pingNum++;
      return ApiResponses.drivingResponse(distanceKm: pingNum * 3.0);
    });

    when(() => apiService.startTrip(any(), any(), deviceId: any(named: 'deviceId')))
        .thenAnswer((_) async => ApiResponses.tripStartedResponse());

    when(() => apiService.endTrip(any(), any()))
        .thenAnswer((_) async => ApiResponses.tripFinalizedResponse(totalKm: 15.0));

    when(() => apiService.finalize())
        .thenAnswer((_) async => ApiResponses.tripFinalizedResponse(totalKm: 15.0));

    when(() => apiService.cancel())
        .thenAnswer((_) async => ApiResponses.tripCancelledResponse());
  }

  void _setupNoDrivingApiResponses() {
    var noDrivingCount = 0;
    when(() => apiService.sendPing(any(), any(), deviceId: any(named: 'deviceId')))
        .thenAnswer((_) async {
      noDrivingCount++;
      return ApiResponses.noCarDrivingResponse(noDrivingCount: noDrivingCount);
    });

    when(() => apiService.startTrip(any(), any(), deviceId: any(named: 'deviceId')))
        .thenAnswer((_) async => ApiResponses.tripStartedResponse());

    when(() => apiService.cancel())
        .thenAnswer((_) async {
      _tripCancelled = true;
      return ApiResponses.tripCancelledResponse();
    });
  }

  // === Trip Lifecycle Methods ===

  /// Start the trip (simulates motion detection trigger)
  Future<void> startTrip() async {
    _tripStarted = true;

    // Get first location
    final location = await locationService.getCurrentLocation();
    if (location != null) {
      await apiService.startTrip(
        location.lat,
        location.lng,
        deviceId: bluetoothService.connectedDevice,
      );
    }

    // Start background tracking
    await locationService.startBackgroundTracking(
      onLocationUpdate: (loc) {
        // This would be called by timer in real code
      },
    );
  }

  /// Trigger a ping (simulates 60-second timer firing)
  Future<Map<String, dynamic>> triggerPing() async {
    _pingCount++;
    locationService.triggerNextPing();

    final location = await locationService.getCurrentLocation();
    if (location == null) {
      return {'status': 'no_location'};
    }

    final response = await apiService.sendPing(
      location.lat,
      location.lng,
      deviceId: bluetoothService.connectedDevice,
    );

    _pingResponses.add(response);
    return response;
  }

  /// End the trip (simulates motion stationary or Bluetooth disconnect)
  Future<void> endTrip() async {
    locationService.stopBackgroundTracking();

    final location = await locationService.getLastKnownLocation();
    if (location != null) {
      final response = await apiService.endTrip(location.lat, location.lng);
      if (response['status'] == 'finalized') {
        _tripFinalized = true;
      }
    }
  }

  /// Force cancel the trip
  Future<void> cancelTrip() async {
    locationService.stopBackgroundTracking();
    await apiService.cancel();
    _tripCancelled = true;
  }

  // === State Accessors ===

  bool get isTripStarted => _tripStarted;
  bool get wasTripFinalized => _tripFinalized;
  bool get wasTripCancelled => _tripCancelled;
  int get pingCount => _pingCount;
  List<Map<String, dynamic>> get pingResponses => List.unmodifiable(_pingResponses);

  /// Get the last ping response
  Map<String, dynamic>? get lastPingResponse =>
      _pingResponses.isNotEmpty ? _pingResponses.last : null;

  /// Check if any ping returned a specific status
  bool hasStatusInResponses(String status) =>
      _pingResponses.any((r) => r['status'] == status);

  // === Verification Helpers ===

  /// Verify startTrip was called with expected coordinates
  void verifyTripStartedAt(double lat, double lng) {
    verify(() => apiService.startTrip(
          any(that: closeTo(lat, 0.001)),
          any(that: closeTo(lng, 0.001)),
          deviceId: any(named: 'deviceId'),
        )).called(1);
  }

  /// Verify a specific number of pings were sent
  void verifyPingCount(int expected) {
    verify(() => apiService.sendPing(
          any(),
          any(),
          deviceId: any(named: 'deviceId'),
        )).called(expected);
  }

  /// Reset all mock services for next test
  void reset() {
    locationService.reset();
    bluetoothService.reset();
    backgroundService.reset();
    _tripStarted = false;
    _tripFinalized = false;
    _tripCancelled = false;
    _pingCount = 0;
    _pingResponses.clear();
  }
}

/// Matcher for approximate double comparison
Matcher closeTo(double value, double delta) => _CloseToMatcher(value, delta);

class _CloseToMatcher extends Matcher {
  final double _value;
  final double _delta;

  _CloseToMatcher(this._value, this._delta);

  @override
  bool matches(Object? item, Map<dynamic, dynamic> matchState) =>
      item is double && (item - _value).abs() <= _delta;

  @override
  Description describe(Description description) =>
      description.add('a value within $_delta of $_value');
}
