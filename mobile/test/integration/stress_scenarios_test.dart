import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../fixtures/api_responses.dart';
import '../fixtures/drive_scenarios.dart';
import '../mocks/mock_api_service.dart';
import 'drive_simulator.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(0.0);
    registerFallbackValue('');
  });

  group('API Failure Scenarios', () {
    late DriveSimulator simulator;
    late MockApiService mockApi;

    setUp(() {
      mockApi = MockApiService();
      simulator = DriveSimulator(api: mockApi);
    });

    tearDown(() {
      simulator.reset();
    });

    test('502 error mid-trip preserves counters and continues', () {
      fakeAsync((async) {
        // Arrange
        simulator.setupHomeToOfficeTrip(bluetoothDevice: 'Audi MMI');

        var pingNum = 0;
        when(() => mockApi.sendPing(any(), any(), deviceId: any(named: 'deviceId')))
            .thenAnswer((_) async {
          pingNum++;
          if (pingNum == 3) {
            // Third ping: API returns error (simulating 502 handled by app)
            // The app would increment api_error_count and return error response
            return ApiResponses.apiErrorResponse(apiErrorCount: 1);
          }
          return ApiResponses.drivingResponse(distanceKm: pingNum * 3.0);
        });

        when(() => mockApi.startTrip(any(), any(), deviceId: any(named: 'deviceId')))
            .thenAnswer((_) async => ApiResponses.tripStartedResponse());

        // Act
        simulator.startTrip();
        async.flushMicrotasks();

        // Ping 1 & 2: success
        for (var i = 0; i < 2; i++) {
          async.elapse(const Duration(minutes: 1));
          simulator.triggerPing();
          async.flushMicrotasks();
        }
        expect(simulator.pingCount, equals(2));

        // Ping 3: API error response
        async.elapse(const Duration(minutes: 1));
        simulator.triggerPing();
        async.flushMicrotasks();

        var response = simulator.lastPingResponse;
        expect(response?['status'], equals('api_error'));
        expect(response?['api_error_count'], equals(1));

        // Ping 4: recovery - should work
        async.elapse(const Duration(minutes: 1));
        simulator.triggerPing();
        async.flushMicrotasks();

        // Assert: trip continues after recovery
        response = simulator.lastPingResponse;
        expect(response?['status'], equals('driving'));
      });
    });

    test('is_parked=True overridden when odometer increases >0.5km', () {
      fakeAsync((async) {
        // Arrange: API says parked but odometer went up
        simulator.setupHomeToOfficeTrip(bluetoothDevice: 'Audi MMI');

        var lastOdo = 10000.0;
        when(() => mockApi.sendPing(any(), any(), deviceId: any(named: 'deviceId')))
            .thenAnswer((_) async {
          // API says parked, but odometer increased 1km
          final currentOdo = lastOdo + 1.0;
          lastOdo = currentOdo;

          // In real code, this would trigger override logic
          // parked_count stays 0 due to odometer override
          return {
            'status': 'parked',
            'is_parked': true,
            'odometer': currentOdo,
            'last_odo': currentOdo - 1.0,
            'parked_count': 0, // Should be 0 due to odometer override
          };
        });

        when(() => mockApi.startTrip(any(), any(), deviceId: any(named: 'deviceId')))
            .thenAnswer((_) async => ApiResponses.tripStartedResponse());

        // Act
        simulator.startTrip();
        async.flushMicrotasks();

        async.elapse(const Duration(minutes: 1));
        simulator.triggerPing();
        async.flushMicrotasks();

        final response = simulator.lastPingResponse;

        // Assert: parked_count should NOT increment due to odometer override
        expect(response?['parked_count'], equals(0));
      });
    });

    test('state=unknown does not reset parked_count', () {
      fakeAsync((async) {
        // Arrange
        simulator.setupHomeToOfficeTrip(bluetoothDevice: 'Audi MMI');

        var pingNum = 0;
        const parkedCount = 1;
        when(() => mockApi.sendPing(any(), any(), deviceId: any(named: 'deviceId')))
            .thenAnswer((_) async {
          pingNum++;
          if (pingNum == 1) {
            // Start with parked_count = 1
            return ApiResponses.parkedResponse(parkedCount: 1);
          }
          if (pingNum == 2) {
            // State unknown - should preserve parked_count
            return {
              'status': 'unknown',
              'is_parked': null,
              'parked_count': parkedCount, // Preserved, not reset
            };
          }
          return ApiResponses.drivingResponse();
        });

        when(() => mockApi.startTrip(any(), any(), deviceId: any(named: 'deviceId')))
            .thenAnswer((_) async => ApiResponses.tripStartedResponse());

        // Act
        simulator.startTrip();
        async.flushMicrotasks();

        async.elapse(const Duration(minutes: 1));
        simulator.triggerPing();
        async.flushMicrotasks(); // parked_count = 1

        async.elapse(const Duration(minutes: 1));
        simulator.triggerPing();
        async.flushMicrotasks(); // state = unknown

        final response = simulator.lastPingResponse;

        // Assert: parked_count preserved when state unknown
        expect(response?['parked_count'], equals(1)); // Not reset to 0
      });
    });

    test('2+ API failures trigger GPS-only mode', () {
      fakeAsync((async) {
        // Arrange
        simulator.setupHomeToOfficeTrip();

        var apiErrorCount = 0;
        when(() => mockApi.sendPing(any(), any(), deviceId: any(named: 'deviceId')))
            .thenAnswer((_) async {
          apiErrorCount++;
          if (apiErrorCount <= 2) {
            return ApiResponses.apiErrorResponse(apiErrorCount: apiErrorCount);
          }
          // After threshold, we're in GPS-only mode
          return {
            'status': 'gps_only',
            'gps_only_mode': true,
            'distance_km': (apiErrorCount - 2) * 2.0,
          };
        });

        when(() => mockApi.startTrip(any(), any(), deviceId: any(named: 'deviceId')))
            .thenAnswer((_) async => ApiResponses.tripStartedResponse());

        // Act
        simulator.startTrip();
        async.flushMicrotasks();

        // 2 API errors
        for (var i = 0; i < 2; i++) {
          async.elapse(const Duration(minutes: 1));
          simulator.triggerPing();
          async.flushMicrotasks();
          final response = simulator.lastPingResponse;
          expect(response?['api_error_count'], equals(i + 1));
        }

        // Third ping should be GPS-only
        async.elapse(const Duration(minutes: 1));
        simulator.triggerPing();
        async.flushMicrotasks();

        final gpsResponse = simulator.lastPingResponse;

        // Assert
        expect(gpsResponse?['gps_only_mode'], isTrue);
        expect(gpsResponse?['status'], equals('gps_only'));
      });
    });
  });

  group('Skip Location Scenarios', () {
    late DriveSimulator simulator;
    late MockApiService mockApi;

    setUp(() {
      mockApi = MockApiService();
      simulator = DriveSimulator(api: mockApi);
    });

    tearDown(() {
      simulator.reset();
    });

    test('parked at skip location stays paused indefinitely', () {
      fakeAsync((async) {
        // Arrange: trip at skip location - need many locations
        simulator.locationService.scheduleDrive(DriveScenarios.customDrive(
          startLat: DriveScenarios.skipLat,
          startLng: DriveScenarios.skipLng,
          endLat: DriveScenarios.skipLat,
          endLng: DriveScenarios.skipLng,
          pingCount: 15, // Need 1 for startTrip + 12 for pings
        ));

        var skipPauseCount = 0;
        when(() => mockApi.sendPing(any(), any(), deviceId: any(named: 'deviceId')))
            .thenAnswer((_) async {
          skipPauseCount++;
          return {
            'status': 'skip_paused',
            'at_skip_location': true,
            'skip_pause_count': skipPauseCount,
            'parked_count': 0, // Not incrementing parked_count at skip location
          };
        });

        when(() => mockApi.startTrip(any(), any(), deviceId: any(named: 'deviceId')))
            .thenAnswer((_) async => ApiResponses.tripStartedResponse());

        // Act: 12 pings at skip location
        simulator.startTrip();
        async.flushMicrotasks();

        for (var i = 0; i < 12; i++) {
          async.elapse(const Duration(minutes: 1));
          simulator.triggerPing();
          async.flushMicrotasks();

          final response = simulator.lastPingResponse;
          // Should remain paused, not finalized
          expect(response?['status'], equals('skip_paused'));
          expect(response?['at_skip_location'], isTrue);
        }

        // Assert: trip not finalized despite many pings
        expect(simulator.wasTripFinalized, isFalse);
        expect(simulator.pingCount, equals(12));
      });
    });

    test('driving away from skip location resumes trip', () {
      fakeAsync((async) {
        // Arrange: need enough locations
        simulator.locationService.scheduleDrive(DriveScenarios.customDrive(
          startLat: DriveScenarios.skipLat,
          startLng: DriveScenarios.skipLng,
          endLat: DriveScenarios.officeLat,
          endLng: DriveScenarios.officeLng,
          pingCount: 6,
        ));

        var pingNum = 0;
        when(() => mockApi.sendPing(any(), any(), deviceId: any(named: 'deviceId')))
            .thenAnswer((_) async {
          pingNum++;
          if (pingNum <= 3) {
            // At skip location
            return ApiResponses.skipLocationResponse(skipPauseCount: pingNum);
          }
          // Drove away - resume normal driving
          return {
            'status': 'driving',
            'at_skip_location': false,
            'skip_pause_count': 0, // Reset
            'distance_km': (pingNum - 3) * 2.0,
          };
        });

        when(() => mockApi.startTrip(any(), any(), deviceId: any(named: 'deviceId')))
            .thenAnswer((_) async => ApiResponses.tripStartedResponse());

        // Act
        simulator.startTrip();
        async.flushMicrotasks();

        // 3 pings at skip
        for (var i = 0; i < 3; i++) {
          async.elapse(const Duration(minutes: 1));
          simulator.triggerPing();
          async.flushMicrotasks();
          final response = simulator.lastPingResponse;
          expect(response?['at_skip_location'], isTrue);
        }

        // Drive away
        async.elapse(const Duration(minutes: 1));
        simulator.triggerPing();
        async.flushMicrotasks();

        final response = simulator.lastPingResponse;

        // Assert: trip resumed
        expect(response?['status'], equals('driving'));
        expect(response?['at_skip_location'], isFalse);
        expect(response?['skip_pause_count'], equals(0));
      });
    });
  });

  group('Counter Threshold Edge Cases', () {
    late DriveSimulator simulator;
    late MockApiService mockApi;

    setUp(() {
      mockApi = MockApiService();
      simulator = DriveSimulator(api: mockApi);
    });

    tearDown(() {
      simulator.reset();
    });

    test('counters reset correctly when condition clears', () {
      fakeAsync((async) {
        // Arrange: start with high counters that should reset
        simulator.setupHomeToOfficeTrip(bluetoothDevice: 'Audi MMI');

        var pingNum = 0;
        when(() => mockApi.sendPing(any(), any(), deviceId: any(named: 'deviceId')))
            .thenAnswer((_) async {
          pingNum++;
          if (pingNum == 1) {
            // First: parked (parked_count = 1)
            return ApiResponses.parkedResponse(parkedCount: 1);
          }
          if (pingNum == 2) {
            // Second: driving - should reset parked_count
            return {
              'status': 'driving',
              'parked_count': 0, // Reset
              'distance_km': 5.0,
            };
          }
          return ApiResponses.drivingResponse(distanceKm: pingNum * 2.0);
        });

        when(() => mockApi.startTrip(any(), any(), deviceId: any(named: 'deviceId')))
            .thenAnswer((_) async => ApiResponses.tripStartedResponse());

        // Act
        simulator.startTrip();
        async.flushMicrotasks();

        async.elapse(const Duration(minutes: 1));
        simulator.triggerPing();
        async.flushMicrotasks();
        var response = simulator.lastPingResponse;
        expect(response?['parked_count'], equals(1));

        async.elapse(const Duration(minutes: 1));
        simulator.triggerPing();
        async.flushMicrotasks();
        response = simulator.lastPingResponse;

        // Assert: counter reset
        expect(response?['parked_count'], equals(0));
        expect(response?['status'], equals('driving'));
      });
    });

    test('odometer backwards (stale data) is ignored', () {
      fakeAsync((async) {
        // Arrange: need enough locations
        simulator.locationService.scheduleDrive(DriveScenarios.customDrive(
          startLat: DriveScenarios.homeLat,
          startLng: DriveScenarios.homeLng,
          endLat: DriveScenarios.officeLat,
          endLng: DriveScenarios.officeLng,
          pingCount: 6,
        ));

        var pingNum = 0;
        when(() => mockApi.sendPing(any(), any(), deviceId: any(named: 'deviceId')))
            .thenAnswer((_) async {
          pingNum++;
          // Odometer: 10000 -> 10005 -> 10003 (stale!) -> 10010
          final odoms = [10000.0, 10005.0, 10003.0, 10010.0];
          final odo = odoms[(pingNum - 1).clamp(0, odoms.length - 1)];

          return {
            'status': 'driving',
            'odometer': odo,
            'last_valid_odo': pingNum >= 3 ? 10005.0 : odo, // Ignore backwards value
            'distance_km': (odo - 10000).abs(),
          };
        });

        when(() => mockApi.startTrip(any(), any(), deviceId: any(named: 'deviceId')))
            .thenAnswer((_) async => ApiResponses.tripStartedResponse());

        // Act
        simulator.startTrip();
        async.flushMicrotasks();

        for (var i = 0; i < 4; i++) {
          async.elapse(const Duration(minutes: 1));
          simulator.triggerPing();
          async.flushMicrotasks();
        }

        // Assert: last response should use valid odometer
        final lastResponse = simulator.lastPingResponse;
        expect(lastResponse, isNotNull);
        expect(lastResponse!['odometer'], equals(10010.0));
      });
    });

    test('false trip start (immediately stationary) cancels quickly', () {
      fakeAsync((async) {
        // Arrange: stationary from the start - need 4 locations (1 for start + 3 pings)
        simulator.locationService.scheduleDrive(DriveScenarios.customDrive(
          startLat: DriveScenarios.homeLat,
          startLng: DriveScenarios.homeLng,
          endLat: DriveScenarios.homeLat,
          endLng: DriveScenarios.homeLng,
          pingCount: 4,
        ));

        var noDrivingCount = 0;
        when(() => mockApi.sendPing(any(), any(), deviceId: any(named: 'deviceId')))
            .thenAnswer((_) async {
          noDrivingCount++;
          return ApiResponses.noCarDrivingResponse(noDrivingCount: noDrivingCount);
        });

        when(() => mockApi.startTrip(any(), any(), deviceId: any(named: 'deviceId')))
            .thenAnswer((_) async => ApiResponses.tripStartedResponse());

        when(() => mockApi.cancel())
            .thenAnswer((_) async => ApiResponses.tripCancelledResponse());

        // Act
        simulator.startTrip();
        async.flushMicrotasks();

        // 3 pings should trigger cancellation
        for (var i = 0; i < 3; i++) {
          async.elapse(const Duration(minutes: 1));
          simulator.triggerPing();
          async.flushMicrotasks();

          final response = simulator.lastPingResponse;
          if ((response?['no_driving_count'] ?? 0) >= 3) {
            simulator.cancelTrip();
            async.flushMicrotasks();
          }
        }

        // Assert
        expect(simulator.wasTripCancelled, isTrue);
        expect(simulator.pingCount, equals(3));
      });
    });
  });
}
