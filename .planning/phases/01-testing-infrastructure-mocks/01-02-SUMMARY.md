---
phase: 01-testing-infrastructure-mocks
plan: 02
subsystem: testing
tags: [flutter, dart, mocks, mocktail, bluetooth, background-service, api-service, fixtures]

# Dependency graph
requires:
  - phase: 01-01
    provides: LocationServiceInterface, FakeLocationService, test directory structure
provides:
  - MockApiService for stubbing webhook responses with mocktail
  - FakeBluetoothService for simulating car Bluetooth connections
  - FakeBackgroundService for simulating native iOS callbacks
  - ApiResponses fixtures for all webhook response scenarios
  - DriveScenarios fixtures with pre-built GPS coordinate sequences
affects: [01-03, 01-04, 01-05]

# Tech tracking
tech-stack:
  added: []
  patterns: [mocktail-mock-pattern, fake-service-pattern, factory-fixtures-pattern]

key-files:
  created:
    - mobile/test/mocks/mock_api_service.dart
    - mobile/test/mocks/fake_bluetooth_service.dart
    - mobile/test/mocks/fake_background_service.dart
    - mobile/test/fixtures/api_responses.dart
    - mobile/test/fixtures/drive_scenarios.dart
  modified: []

key-decisions:
  - "Used mocktail Mock for ApiService (auto-stub pattern) vs Fake for Bluetooth/Background (stateful simulation)"
  - "Package name is zero_click not mileage_tracker - corrected all imports"
  - "BluetoothService and BackgroundService don't have abstract interfaces, so Fakes don't use implements keyword"

patterns-established:
  - "Mock vs Fake: Use mocktail Mock for API services (stub responses), Fake for native services (simulate callbacks)"
  - "Fixture factories: Static methods with named parameters for flexible test data generation"
  - "Coordinate fixtures: Use Rotterdam area coordinates matching CLAUDE.md config values"

issues-created: []

# Metrics
duration: 12min
completed: 2026-01-19
---

# Plan 01-02: Flutter Mock Services Summary

**MockApiService, FakeBluetoothService, FakeBackgroundService, and comprehensive fixtures for webhook responses and drive scenarios**

## Performance

- **Duration:** 12 min
- **Started:** 2026-01-19T10:15:00Z
- **Completed:** 2026-01-19T10:27:00Z
- **Tasks:** 3
- **Files modified:** 5

## Accomplishments
- Created MockApiService with mocktail for stubbing all webhook flows
- Built FakeBluetoothService with simulateConnect/simulateDisconnect for car detection testing
- Built FakeBackgroundService with simulate* methods for all native iOS callbacks
- Created ApiResponses fixture class covering driving, parked, no_car_driving, api_error, gps_only, skip_paused scenarios
- Created DriveScenarios with homeToOffice, officeToHome, tooShortTrip, tripWithSkipLocation, stationaryTrip, tripWithTraffic, highwayTrip, roundTrip, variableSpeedDrive, customDrive

## Task Commits

Each task was committed atomically:

1. **Task 1: Create MockApiService with mocktail** - `00d01d1` (feat)
2. **Task 2: Create FakeBluetoothService and FakeBackgroundService** - `bd574ad` (feat)
3. **Task 3: Create API response fixtures and drive scenario fixtures** - `4399d49` (feat)

## Files Created/Modified
- `mobile/test/mocks/mock_api_service.dart` - Mocktail mock for ApiService with fallback registration helper
- `mobile/test/mocks/fake_bluetooth_service.dart` - Fake Bluetooth service with simulate* methods
- `mobile/test/mocks/fake_background_service.dart` - Fake Background service with all native callback simulations
- `mobile/test/fixtures/api_responses.dart` - Factory methods for all webhook response types
- `mobile/test/fixtures/drive_scenarios.dart` - Pre-built GPS coordinate sequences for testing

## Decisions Made
- Used mocktail Mock for ApiService because tests only need to stub specific method responses (not simulate complex state)
- Used Fake implementations for BluetoothService and BackgroundService because they need stateful simulation of native callbacks
- BluetoothService and BackgroundService don't have abstract interfaces in the codebase, so Fakes implement the same public API without using `implements` keyword
- Added extra drive scenarios beyond plan (highwayTrip, roundTrip, variableSpeedDrive) for more comprehensive test coverage

## Deviations from Plan

### Auto-fixed Issues

**1. [Rule 3 - Blocking] Corrected package import name**
- **Found during:** Task 1 (MockApiService creation)
- **Issue:** Plan example used `package:mileage_tracker/...` but actual package name is `zero_click`
- **Fix:** Changed all imports to `package:zero_click/...`
- **Files modified:** mock_api_service.dart, fake_bluetooth_service.dart, fake_background_service.dart, drive_scenarios.dart
- **Verification:** flutter analyze passes with only info-level lints
- **Committed in:** All task commits

**2. [Rule 3 - Blocking] Removed unused imports from MockApiService**
- **Found during:** Task 1 (MockApiService creation)
- **Issue:** Initial version had unused model imports causing analyzer warnings
- **Fix:** Removed imports, documented needed imports in doc comments
- **Files modified:** mock_api_service.dart
- **Verification:** flutter analyze shows no warnings
- **Committed in:** 00d01d1 (Task 1 commit)

**3. [Rule 4 - Trivial Enhancement] Added extra drive scenarios**
- **Found during:** Task 3 (Drive scenarios creation)
- **Issue:** Plan only specified 5 scenarios, but more patterns useful for thorough testing
- **Fix:** Added highwayTrip, roundTrip, variableSpeedDrive, officeToHome scenarios
- **Files modified:** drive_scenarios.dart
- **Verification:** Additional scenarios improve test coverage
- **Committed in:** 4399d49 (Task 3 commit)

---

**Total deviations:** 3 auto-fixed (2 blocking import fixes, 1 trivial enhancement), 0 deferred
**Impact on plan:** Import corrections necessary for code to compile. Extra scenarios improve test coverage.

## Issues Encountered
- Pre-existing error in widget_test.dart (wrong package name) - not related to this plan, ignored per previous plan guidance

## Next Phase Readiness
- MockApiService ready for Plan 03 (webhook service tests)
- FakeBluetoothService ready for Plan 04 (car detection tests)
- FakeBackgroundService ready for Plan 05 (drive simulation integration tests)
- All fixtures ready for use across test plans
- Combined with FakeLocationService from Plan 01, all mock infrastructure is complete

---
*Phase: 01-testing-infrastructure-mocks*
*Plan: 02*
*Completed: 2026-01-19*
