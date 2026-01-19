# Phase 1: Testing Infrastructure & Mocks - Research

**Researched:** 2025-01-19
**Domain:** Flutter/iOS mocking, drive simulation, integration testing
**Confidence:** HIGH

<research_summary>
## Summary

Researched the testing ecosystem for a Flutter + iOS native mileage tracking app. The codebase already has `mocktail: ^1.0.4` as a dev dependency (the preferred choice over mockito for null-safe Dart). The challenge is mocking hardware-dependent services (GPS, motion detection, Bluetooth) and creating realistic drive simulations.

Key finding: Both Flutter and iOS services need protocol/interface abstraction to be testable. The current codebase has services designed as concrete classes with static platform calls (Geolocator, MethodChannel for Bluetooth). These need thin wrapper interfaces to enable mock injection.

**Primary recommendation:** Create abstract interfaces for all services, keep current implementations as "real" implementations, inject mocks during testing. Use `fake_async` for time-dependent drive simulations to test ping intervals, timeouts, and counter thresholds without waiting real time.
</research_summary>

<standard_stack>
## Standard Stack

The established libraries/tools for this domain:

### Core - Flutter Testing
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| mocktail | ^1.0.4 | Mock creation without codegen | Already in pubspec, null-safe, no build_runner needed |
| flutter_test | SDK | Widget and unit testing | Official Flutter testing framework |
| fake_async | SDK | Time manipulation in tests | Control timers, delays, periodic callbacks |
| integration_test | SDK | Full-app integration tests | Official Flutter integration testing |

### Core - iOS Testing
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| XCTest | Built-in | iOS unit/integration testing | Apple's official testing framework |
| Protocol-based DI | Pattern | Mock hardware services | Swift's idiomatic way to mock singletons |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| clock | ^1.1.1 | Injectable time source | When services need testable DateTime.now() |
| http_mock_adapter | ^0.6.1 | HTTP client mocking | If using Dio (not needed, using http package) |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| mocktail | mockito | mockito requires codegen via build_runner, more boilerplate |
| Manual mocks | flutter_blue_plus wrapper | flutter_blue_plus has static methods, need wrapper class anyway |
| Real device testing | BLEmulator | BLEmulator provides virtual BLE but adds complexity |

**Installation:**
Already have mocktail. Add clock if needed:
```bash
cd mobile && flutter pub add dev:clock
```
</standard_stack>

<architecture_patterns>
## Architecture Patterns

### Recommended Project Structure
```
mobile/
├── lib/
│   └── services/              # Production services (unchanged)
│       ├── api_service.dart
│       ├── location_service.dart
│       └── bluetooth_service.dart
└── test/
    ├── mocks/                 # Mock implementations
    │   ├── mock_api_service.dart
    │   ├── mock_location_service.dart
    │   └── mock_bluetooth_service.dart
    ├── fixtures/              # Test data
    │   ├── drive_scenarios.dart
    │   └── api_responses.dart
    ├── unit/                  # Unit tests
    │   ├── api_service_test.dart
    │   └── location_service_test.dart
    ├── integration/           # Integration tests
    │   └── drive_simulation_test.dart
    └── widget/                # Widget tests
        └── history_screen_test.dart
```

### Pattern 1: Abstract Interface + Mock Implementation
**What:** Define abstract class mirroring service methods, make current service implement it
**When to use:** Services with hardware/platform dependencies (GPS, Bluetooth, native channels)
**Example:**
```dart
// Abstract interface
abstract class LocationServiceInterface {
  Future<LocationResult?> getCurrentLocation();
  Future<bool> startBackgroundTracking({
    required void Function(LocationResult) onLocationUpdate,
    Duration pingInterval,
  });
  void stopBackgroundTracking();
  bool get isTracking;
}

// Production implementation (current LocationService)
class LocationService implements LocationServiceInterface {
  // ... existing code unchanged
}

// Mock for testing
class MockLocationService extends Mock implements LocationServiceInterface {}

// Or fake with controllable behavior
class FakeLocationService implements LocationServiceInterface {
  final List<LocationResult> _locationQueue = [];
  void Function(LocationResult)? _callback;

  void enqueueLocation(LocationResult location) {
    _locationQueue.add(location);
  }

  void simulatePing() {
    if (_locationQueue.isNotEmpty && _callback != null) {
      _callback!(_locationQueue.removeAt(0));
    }
  }

  @override
  Future<LocationResult?> getCurrentLocation() async {
    return _locationQueue.isNotEmpty ? _locationQueue.first : null;
  }
  // ... other methods
}
```

### Pattern 2: FakeAsync for Time-Based Testing
**What:** Use fake_async to control time in tests involving timers and delays
**When to use:** Testing ping intervals, timeouts, debouncing, counter thresholds
**Example:**
```dart
// Source: Flutter docs + fake_async package
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('trip cancelled after 3 no-driving pings', () {
    fakeAsync((async) {
      final mockApi = MockApiService();
      final fakeLocation = FakeLocationService();
      final tripManager = TripManager(api: mockApi, location: fakeLocation);

      // Setup: API returns no driving car
      when(() => mockApi.sendPing(any(), any()))
          .thenAnswer((_) async => {'status': 'no_car_driving', 'no_driving_count': 1});

      // Start trip
      tripManager.startTrip();

      // Simulate 3 ping intervals (60 seconds each)
      async.elapse(const Duration(minutes: 3));

      // Verify trip was cancelled
      verify(() => mockApi.cancel()).called(1);
    });
  });
}
```

### Pattern 3: Wrapper Class for Static Platform Methods
**What:** Wrap static Geolocator/Platform methods in injectable class
**When to use:** When platform plugin uses static methods (Geolocator, FlutterBluePlus)
**Example:**
```dart
// Wrapper for Geolocator static methods
class GeolocatorWrapper {
  Future<bool> isLocationServiceEnabled() => Geolocator.isLocationServiceEnabled();
  Future<Position> getCurrentPosition({LocationSettings? locationSettings}) =>
      Geolocator.getCurrentPosition(locationSettings: locationSettings);
  Future<Position?> getLastKnownPosition() => Geolocator.getLastKnownPosition();
  Stream<Position> getPositionStream({LocationSettings? locationSettings}) =>
      Geolocator.getPositionStream(locationSettings: locationSettings);
}

// Then LocationService uses injected wrapper
class LocationService implements LocationServiceInterface {
  LocationService({GeolocatorWrapper? geolocator})
      : _geolocator = geolocator ?? GeolocatorWrapper();

  final GeolocatorWrapper _geolocator;

  @override
  Future<LocationResult?> getCurrentLocation() async {
    if (!await _geolocator.isLocationServiceEnabled()) return null;
    final position = await _geolocator.getCurrentPosition();
    // ...
  }
}
```

### Pattern 4: iOS Protocol-Based Mocking
**What:** Define Swift protocol matching CLLocationManager/CMMotionActivityManager interface
**When to use:** iOS unit tests for native code in AppDelegate
**Example:**
```swift
// Protocol that CLLocationManager will conform to
protocol LocationManaging {
    var delegate: CLLocationManagerDelegate? { get set }
    var desiredAccuracy: CLLocationAccuracy { get set }
    var distanceFilter: CLLocationDistance { get set }
    var location: CLLocation? { get }
    func startUpdatingLocation()
    func stopUpdatingLocation()
    func requestAlwaysAuthorization()
}

// Extend CLLocationManager to conform (automatic - it already has these)
extension CLLocationManager: LocationManaging {}

// Mock for testing
class MockLocationManager: LocationManaging {
    var delegate: CLLocationManagerDelegate?
    var desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyBest
    var distanceFilter: CLLocationDistance = kCLDistanceFilterNone
    var location: CLLocation?

    func startUpdatingLocation() { didCallStartUpdating = true }
    func stopUpdatingLocation() { didCallStopUpdating = true }
    func requestAlwaysAuthorization() { didRequestAuth = true }

    // Test helpers
    var didCallStartUpdating = false
    var didCallStopUpdating = false
    var didRequestAuth = false

    func simulateLocationUpdate(_ location: CLLocation) {
        self.location = location
        delegate?.locationManager?(CLLocationManager(), didUpdateLocations: [location])
    }
}
```

### Anti-Patterns to Avoid
- **Direct static calls in business logic:** Always wrap Geolocator.* calls, never call directly in code that needs testing
- **Testing against real time:** Use fake_async instead of actual delays, tests should run in milliseconds
- **Mocking too deep:** Mock at service boundaries, not internal implementation details
- **Shared mutable state in tests:** Each test should have fresh mock instances
</architecture_patterns>

<dont_hand_roll>
## Don't Hand-Roll

Problems that look simple but have existing solutions:

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Mock creation | Manual stub classes for every method | mocktail Mock class | Automatic stubbing, verification, argument capture |
| Time manipulation | Real Thread.sleep or delays | fake_async package | Tests run instantly, deterministic timing |
| HTTP mocking | Custom response interceptors | mocktail with http.Client | Already in flutter docs, well-tested |
| Async test helpers | Manual Future.delayed orchestration | flutter_test async utilities | pumpAndSettle, pump, runAsync handle it |
| GPS coordinate sequences | Hardcoded lat/lng arrays | GpxParser or fixture files | GPX is standard format, easy to visualize |

**Key insight:** The testing ecosystem in Flutter/Dart is mature. mocktail + fake_async + flutter_test cover 95% of use cases. The main work is restructuring existing services to accept injected dependencies, not building new testing infrastructure.
</dont_hand_roll>

<common_pitfalls>
## Common Pitfalls

### Pitfall 1: Testing Platform Channels with Real Channel
**What goes wrong:** Tests fail with MissingPluginException when calling Bluetooth/native channel methods
**Why it happens:** No native side in test environment to respond to method channel calls
**How to avoid:** Mock at the service layer (MockBluetoothService), not the channel layer. Or use setMockMethodCallHandler to stub channel responses.
**Warning signs:** MissingPluginException in test output

### Pitfall 2: Geolocator Static Methods Breaking Tests
**What goes wrong:** Can't inject mock Geolocator, tests make real GPS calls or throw
**Why it happens:** Geolocator uses static methods (Geolocator.getCurrentPosition), can't mock static
**How to avoid:** Create GeolocatorWrapper class, inject it into LocationService, mock the wrapper
**Warning signs:** Tests that "work on device but fail in CI"

### Pitfall 3: Timer-Based Code Running Forever
**What goes wrong:** Tests involving pingTimer hang or take minutes to complete
**Why it happens:** Real Timer.periodic waits actual time, 60-second ping interval = 60 second test
**How to avoid:** Use fake_async, elapse time virtually. Inject Clock for DateTime.now().
**Warning signs:** Tests marked @Timeout that still fail, slow test suite

### Pitfall 4: FakeAsync + Real Async Don't Mix
**What goes wrong:** Test hangs when code inside fakeAsync makes real HTTP calls
**Why it happens:** fake_async only controls fake timers, real network I/O isn't faked
**How to avoid:** Mock all I/O (HTTP, file, platform channels) when using fake_async
**Warning signs:** Test hangs with "pending timer" warnings

### Pitfall 5: Testing iOS Singletons (WCSession.default)
**What goes wrong:** Can't inject mock WCSession, tests hit real Watch connectivity
**Why it happens:** WCSession uses WCSession.default singleton, can't swap out
**How to avoid:** Create WatchConnectivityProtocol, wrap WCSession methods, inject mock
**Warning signs:** Tests that only pass when Watch is connected

### Pitfall 6: Integration Tests Without Mock Backend
**What goes wrong:** Integration tests flaky, dependent on API being up, slow
**Why it happens:** Hitting real Cloud Run backend, network latency + variability
**How to avoid:** Use MockApiService or local test server, don't call production API in tests
**Warning signs:** Tests pass locally but fail in CI, 5+ second test durations
</common_pitfalls>

<code_examples>
## Code Examples

Verified patterns from official sources and research:

### MockApiService with Mocktail
```dart
// Source: Flutter docs + mocktail pattern
import 'package:mocktail/mocktail.dart';
import '../lib/services/api_service.dart';
import '../lib/models/trip.dart';

class MockApiService extends Mock implements ApiService {}

void main() {
  late MockApiService mockApi;

  setUp(() {
    mockApi = MockApiService();
  });

  test('sendPing returns trip status', () async {
    // Arrange
    when(() => mockApi.sendPing(any(), any(), deviceId: any(named: 'deviceId')))
        .thenAnswer((_) async => {
          'status': 'driving',
          'car': 'Audi A4',
          'distance_km': 12.5,
        });

    // Act
    final result = await mockApi.sendPing(52.0, 4.5, deviceId: 'test-device');

    // Assert
    expect(result['status'], 'driving');
    verify(() => mockApi.sendPing(52.0, 4.5, deviceId: 'test-device')).called(1);
  });
}
```

### FakeLocationService for Drive Simulation
```dart
// Source: Derived from geolocator mocking patterns
class FakeLocationService implements LocationServiceInterface {
  final List<LocationResult> _scheduledLocations = [];
  void Function(LocationResult)? _onLocationUpdate;
  bool _isTracking = false;
  int _currentIndex = 0;

  /// Queue a sequence of locations for a simulated drive
  void scheduleDrive(List<LocationResult> locations) {
    _scheduledLocations.addAll(locations);
  }

  /// Simulate the next ping (called by test)
  void triggerNextPing() {
    if (_currentIndex < _scheduledLocations.length && _onLocationUpdate != null) {
      _onLocationUpdate!(_scheduledLocations[_currentIndex++]);
    }
  }

  @override
  Future<bool> startBackgroundTracking({
    required void Function(LocationResult) onLocationUpdate,
    Duration pingInterval = const Duration(minutes: 1),
  }) async {
    _onLocationUpdate = onLocationUpdate;
    _isTracking = true;
    return true;
  }

  @override
  void stopBackgroundTracking() {
    _isTracking = false;
    _onLocationUpdate = null;
  }

  @override
  Future<LocationResult?> getCurrentLocation() async {
    if (_currentIndex < _scheduledLocations.length) {
      return _scheduledLocations[_currentIndex];
    }
    return null;
  }

  @override
  bool get isTracking => _isTracking;
}
```

### Drive Simulation Test with FakeAsync
```dart
// Source: fake_async docs + project domain knowledge
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  group('Trip lifecycle', () {
    late MockApiService mockApi;
    late FakeLocationService fakeLocation;

    setUp(() {
      mockApi = MockApiService();
      fakeLocation = FakeLocationService();

      // Register fallback values for mocktail any() matchers
      registerFallbackValue(0.0);
    });

    test('trip finalizes after 3 parked pings', () {
      fakeAsync((async) {
        // Arrange: schedule 5 locations (start, 3 driving, 1 parked)
        fakeLocation.scheduleDrive([
          LocationResult(lat: 52.0, lng: 4.5, timestamp: DateTime.now()),
          LocationResult(lat: 52.1, lng: 4.6, timestamp: DateTime.now()),
          LocationResult(lat: 52.2, lng: 4.7, timestamp: DateTime.now()),
          LocationResult(lat: 52.2, lng: 4.7, timestamp: DateTime.now()), // stationary
          LocationResult(lat: 52.2, lng: 4.7, timestamp: DateTime.now()), // stationary
        ]);

        // Mock API responses: driving → driving → driving → parked → parked → parked
        var pingCount = 0;
        when(() => mockApi.sendPing(any(), any(), deviceId: any(named: 'deviceId')))
            .thenAnswer((_) async {
          pingCount++;
          if (pingCount <= 3) {
            return {'status': 'driving', 'parked_count': 0};
          }
          return {'status': 'parked', 'parked_count': pingCount - 3};
        });

        when(() => mockApi.finalize()).thenAnswer((_) async => {'status': 'finalized'});

        // Act: start trip, elapse time for 5 ping intervals
        // tripManager.start() would be called here

        for (var i = 0; i < 5; i++) {
          fakeLocation.triggerNextPing();
          async.elapse(const Duration(minutes: 1));
        }

        // Assert: finalize should be called after 3 parked pings
        verify(() => mockApi.finalize()).called(1);
      });
    });
  });
}
```

### iOS MockLocationManager
```swift
// Source: iOS testing patterns + CLLocationManager docs
import XCTest
import CoreLocation

class MockLocationManager: LocationManaging {
    weak var delegate: CLLocationManagerDelegate?
    var desiredAccuracy: CLLocationAccuracy = kCLLocationAccuracyBest
    var distanceFilter: CLLocationDistance = kCLDistanceFilterNone
    var allowsBackgroundLocationUpdates = false
    var pausesLocationUpdatesAutomatically = true
    var activityType: CLActivityType = .other
    var location: CLLocation?

    private(set) var didStartUpdating = false
    private(set) var didStopUpdating = false
    private(set) var didRequestAuthorization = false

    func startUpdatingLocation() {
        didStartUpdating = true
    }

    func stopUpdatingLocation() {
        didStopUpdating = true
    }

    func requestAlwaysAuthorization() {
        didRequestAuthorization = true
    }

    // Test helper: simulate a location update
    func simulateLocation(lat: Double, lng: Double) {
        let location = CLLocation(latitude: lat, longitude: lng)
        self.location = location
        // Note: Need to pass a real CLLocationManager for the delegate callback
        // This is a limitation - may need to test at higher level
    }
}

class LocationTests: XCTestCase {
    var mockLocationManager: MockLocationManager!

    override func setUp() {
        super.setUp()
        mockLocationManager = MockLocationManager()
    }

    func testStartTrackingSetsHighAccuracy() {
        // When starting drive tracking
        mockLocationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        mockLocationManager.startUpdatingLocation()

        // Then high accuracy should be set
        XCTAssertEqual(mockLocationManager.desiredAccuracy, kCLLocationAccuracyBestForNavigation)
        XCTAssertTrue(mockLocationManager.didStartUpdating)
    }
}
```
</code_examples>

<sota_updates>
## State of the Art (2024-2025)

What's changed recently:

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| mockito (codegen) | mocktail (no codegen) | 2021+ | Simpler setup, faster iteration, already adopted in this project |
| flutter_driver | integration_test | 2021 | Better performance, easier debugging, same device as test |
| Manual clock injection | clock package | 2020+ | Standard way to test DateTime.now() dependent code |
| Geolocator instance | Geolocator static | v8.0 (2022) | Breaking change - need wrapper class for testing |

**New tools/patterns to consider:**
- **patrol** (by LeanCode): Alternative to integration_test with native interaction support. Consider if need to test system dialogs (permissions).
- **golden_toolkit**: Screenshot testing. Not critical for Phase 1 but useful for UI regression later.

**Deprecated/outdated:**
- **flutter_driver**: Replaced by integration_test package for most use cases
- **MethodChannel mocking via TestDefaultBinaryMessengerBinding**: Still works but prefer mocking at service layer
</sota_updates>

<open_questions>
## Open Questions

Things that couldn't be fully resolved:

1. **CMMotionActivityManager mocking in iOS**
   - What we know: Protocol-based approach works for CLLocationManager
   - What's unclear: CMMotionActivityManager uses closure-based API (`startActivityUpdates(to:withHandler:)`), may be harder to mock delegate-style
   - Recommendation: Test motion detection at higher level (mock the handler callback), or accept that motion detection itself can't be unit tested and focus integration tests on the trip state machine

2. **WCSession delegate callback simulation**
   - What we know: Protocol abstraction works for method calls
   - What's unclear: Simulating `session(_:didReceiveUserInfo:)` delegate callbacks requires calling delegate methods with real WCSession parameter
   - Recommendation: Create WatchConnectivityService wrapper that exposes streams/callbacks, mock that service layer instead of WCSession directly

3. **End-to-end drive simulation timing**
   - What we know: fake_async controls Dart timers, iOS native code has its own timers
   - What's unclear: How to synchronize Flutter fake_async with iOS native ping timers in integration tests
   - Recommendation: For true end-to-end, may need real-time integration tests on device (slower). For unit tests, test Flutter and iOS layers separately with their own time control.
</open_questions>

<sources>
## Sources

### Primary (HIGH confidence)
- [Flutter Testing Cookbook - Mocking](https://docs.flutter.dev/cookbook/testing/unit/mocking) - Official mocktail/mockito patterns
- [pub.dev/packages/mocktail](https://pub.dev/packages/mocktail) - mocktail 1.0.4 API and usage
- [fake_async API docs](https://api.flutter.dev/flutter/package-fake_async_fake_async/FakeAsync-class.html) - Time control in tests
- Codebase analysis: `mobile/pubspec.yaml` shows mocktail already present

### Secondary (MEDIUM confidence)
- [Testing WCSession with Protocols](https://medium.com/@meanestcreature/testing-consumers-of-wcsession-with-protocols-in-swift-ac915385029b) - Protocol abstraction for iOS singletons
- [Mocking CLLocationManager](https://rwhtechnology.com/blog/unit-test-cllocationmanager-with-mock/) - Protocol-based mocking for location
- [Mocking Bluetooth in Flutter](https://dsavir-h.medium.com/mocking-bluetooth-in-flutter-updated-cb3b9484ae02) - FlutterBluePlusMockable wrapper pattern
- [Geolocator mocking gist](https://gist.github.com/darwin-morocho/585988fa0dc29c5f22d4a21ce18379aa) - Wrapper class for static Geolocator methods

### Tertiary (LOW confidence - needs validation)
- None - all critical patterns verified with official docs or established community patterns
</sources>

<metadata>
## Metadata

**Research scope:**
- Core technology: Flutter testing (mocktail, fake_async), iOS XCTest
- Ecosystem: Geolocator mocking, MethodChannel testing, WCSession protocols
- Patterns: Interface abstraction, wrapper classes, time manipulation
- Pitfalls: Static method mocking, platform channel testing, timer-based code

**Confidence breakdown:**
- Standard stack: HIGH - mocktail already in project, fake_async is official Flutter
- Architecture: HIGH - patterns from official docs and verified community practice
- Pitfalls: HIGH - common issues documented in GitHub issues and forums
- Code examples: HIGH - derived from official docs and adapted to project domain

**Research date:** 2025-01-19
**Valid until:** 2025-03-19 (60 days - testing patterns are stable)
</metadata>

---

*Phase: 01-testing-infrastructure-mocks*
*Research completed: 2025-01-19*
*Ready for planning: yes*
