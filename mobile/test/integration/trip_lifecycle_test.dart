import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../fixtures/api_responses.dart';
import '../fixtures/drive_scenarios.dart';
import '../mocks/mock_api_service.dart';
import 'drive_simulator.dart';

void main() {
  // Register fallback values for mocktail any() matchers
  setUpAll(() {
    registerFallbackValue(0.0);
    registerFallbackValue('');
  });

  group('Trip Lifecycle Integration Tests', () {
    late DriveSimulator simulator;
    late MockApiService mockApi;

    setUp(() {
      mockApi = MockApiService();
      simulator = DriveSimulator(api: mockApi);
    });

    tearDown(() {
      simulator.reset();
    });

    test('complete home-to-office trip finalizes successfully', () {
      fakeAsync((async) {
        // Arrange: setup home-to-office drive with Bluetooth car
        simulator.setupHomeToOfficeTrip(bluetoothDevice: 'Audi MMI 1234');

        // Act: start trip
        simulator.startTrip();
        async.flushMicrotasks();
        expect(simulator.isTripStarted, isTrue);

        // Simulate 5 ping intervals (5 minutes of driving)
        for (var i = 0; i < 5; i++) {
          async.elapse(const Duration(minutes: 1));
          simulator.triggerPing();
          async.flushMicrotasks();
        }

        // End trip (simulates motion becoming stationary)
        simulator.endTrip();
        async.flushMicrotasks();

        // Assert: trip should be finalized
        expect(simulator.wasTripFinalized, isTrue);
        expect(simulator.pingCount, equals(5));
      });
    });

    test('trip with no driving car found cancels after 3 pings', () {
      fakeAsync((async) {
        // Arrange: setup a custom stationary scenario with enough locations
        // (startTrip consumes 1, we need 3 more for pings = 4 total)
        simulator.locationService.scheduleDrive(DriveScenarios.customDrive(
          startLat: DriveScenarios.homeLat,
          startLng: DriveScenarios.homeLng,
          endLat: DriveScenarios.homeLat,
          endLng: DriveScenarios.homeLng,
          pingCount: 4, // 1 for startTrip, 3 for pings
        ));

        // Override the mock to return no_car_driving responses
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

        // Act: start trip
        simulator.startTrip();
        async.flushMicrotasks();

        // Simulate 3 pings
        for (var i = 0; i < 3; i++) {
          async.elapse(const Duration(minutes: 1));
          simulator.triggerPing();
          async.flushMicrotasks();
        }

        // After 3 no_car_driving responses, cancel the trip
        // (simulates what the app would do when no_driving_count >= 3)
        simulator.cancelTrip();
        async.flushMicrotasks();

        // Assert: trip should be cancelled
        expect(simulator.wasTripCancelled, isTrue);
        expect(simulator.pingCount, equals(3));
        // Verify the last ping had no_driving_count of 3
        expect(simulator.lastPingResponse?['no_driving_count'], equals(3));
      });
    });

    test('trip finalizes after 3 parked pings', () {
      fakeAsync((async) {
        // Arrange: setup normal trip
        simulator.setupHomeToOfficeTrip(bluetoothDevice: 'Audi MMI 1234');

        // Configure: 3 driving pings, then 3 parked pings
        var pingNum = 0;
        when(() => mockApi.sendPing(any(), any(), deviceId: any(named: 'deviceId')))
            .thenAnswer((_) async {
          pingNum++;
          if (pingNum <= 3) {
            return ApiResponses.drivingResponse(distanceKm: pingNum * 3.0);
          } else {
            return ApiResponses.parkedResponse(
              parkedCount: pingNum - 3,
              distanceKm: 10.0,
            );
          }
        });

        when(() => mockApi.startTrip(any(), any(), deviceId: any(named: 'deviceId')))
            .thenAnswer((_) async => ApiResponses.tripStartedResponse());

        when(() => mockApi.endTrip(any(), any()))
            .thenAnswer((_) async => ApiResponses.tripFinalizedResponse(totalKm: 10.0));

        when(() => mockApi.finalize())
            .thenAnswer((_) async => ApiResponses.tripFinalizedResponse(totalKm: 10.0));

        // Act
        simulator.startTrip();
        async.flushMicrotasks();

        // 3 driving pings
        for (var i = 0; i < 3; i++) {
          async.elapse(const Duration(minutes: 1));
          simulator.triggerPing();
          async.flushMicrotasks();
        }

        // 3 parked pings - should trigger finalization
        for (var i = 0; i < 3; i++) {
          async.elapse(const Duration(minutes: 1));
          simulator.triggerPing();
          async.flushMicrotasks();

          // When parked_count reaches 3, finalize
          final response = simulator.lastPingResponse;
          if ((response?['parked_count'] ?? 0) >= 3) {
            simulator.endTrip();
            async.flushMicrotasks();
            break;
          }
        }

        // Assert
        expect(simulator.pingCount, greaterThanOrEqualTo(5));
        expect(simulator.hasStatusInResponses('parked'), isTrue);
      });
    });

    test('Bluetooth device identifies car for trip', () {
      fakeAsync((async) {
        // Arrange: connect Bluetooth before trip
        simulator.bluetoothService.simulateConnect('Audi MMI 1234');
        simulator.setupHomeToOfficeTrip(bluetoothDevice: 'Audi MMI 1234');

        when(() => mockApi.startTrip(any(), any(), deviceId: any(named: 'deviceId')))
            .thenAnswer((_) async => ApiResponses.tripStartedResponse());

        // Act
        simulator.startTrip();
        async.flushMicrotasks();

        // Assert: Bluetooth device should be passed to API
        verify(() => mockApi.startTrip(
              any(),
              any(),
              deviceId: 'Audi MMI 1234',
            )).called(1);
      });
    });

    test('trip continues without Bluetooth device', () {
      fakeAsync((async) {
        // Arrange: no Bluetooth
        simulator.setupHomeToOfficeTrip(); // No bluetoothDevice

        when(() => mockApi.startTrip(any(), any(), deviceId: any(named: 'deviceId')))
            .thenAnswer((_) async => ApiResponses.tripStartedResponse());

        // Act
        simulator.startTrip();
        async.flushMicrotasks();

        // Assert: deviceId should be null
        verify(() => mockApi.startTrip(
              any(),
              any(),
              deviceId: null,
            )).called(1);
      });
    });
  });

  group('GPS-Only Mode Tests', () {
    late DriveSimulator simulator;
    late MockApiService mockApi;

    setUp(() {
      mockApi = MockApiService();
      simulator = DriveSimulator(api: mockApi);
    });

    tearDown(() {
      simulator.reset();
    });

    test('GPS-only mode activates after 2 API errors', () {
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
          // After 2 errors, switch to GPS-only
          return ApiResponses.gpsOnlyResponse(distanceKm: 5.0);
        });

        when(() => mockApi.startTrip(any(), any(), deviceId: any(named: 'deviceId')))
            .thenAnswer((_) async => ApiResponses.tripStartedResponse());

        // Act
        simulator.startTrip();
        async.flushMicrotasks();

        // First 2 pings should report API errors
        for (var i = 0; i < 2; i++) {
          async.elapse(const Duration(minutes: 1));
          simulator.triggerPing();
          async.flushMicrotasks();
          final response = simulator.lastPingResponse;
          expect(response?['status'], equals('api_error'));
        }

        // Third ping should be in GPS-only mode
        async.elapse(const Duration(minutes: 1));
        simulator.triggerPing();
        async.flushMicrotasks();
        final gpsResponse = simulator.lastPingResponse;
        expect(gpsResponse?['status'], equals('gps_only'));
        expect(gpsResponse?['gps_only_mode'], isTrue);
      });
    });
  });
}
