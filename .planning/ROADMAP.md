# Roadmap: Zero Click iOS App Store Release

## Overview

Transform Zero Click from a functional personal-use app into a production-ready iOS App Store release. **Testing infrastructure comes first** - we build comprehensive mocks and drive simulation before any refactoring, ensuring we can catch regressions immediately.

## Domain Expertise

None (standard Flutter/Swift development patterns)

## Phases

**Phase Numbering:**
- Integer phases (1, 2, 3): Planned milestone work
- Decimal phases (2.1, 2.2): Urgent insertions (marked with INSERTED)

- [x] **Phase 1: Testing Infrastructure & Mocks** - Mock services, drive simulation, test foundation ✓
- [x] **Phase 2: iOS Native Architecture** - Extract services from AppDelegate monolith ✓
- [x] **Phase 2.1: iOS Testing Infrastructure** - iOS XCTests with mock services (INSERTED) ✓
- [x] **Phase 3: Motion Detection Hardening** - Fix hysteresis, debouncing, state machine reliability ✓
- [x] **Phase 4: Flutter Provider Split** - Break AppProvider into focused providers ✓
- [x] **Phase 5: Flutter UI Refactoring** - Split oversized screen files ✓
- [x] **Phase 6.1: Firestore Optimization** - Fix 590K reads/day via smart polling, denormalization (INSERTED/URGENT) ✓
- [x] **Phase 6: Error Handling & Logging** - Crash reporting, structured logging, user feedback ✓
- [x] **Phase 6.2: Firebase Analytics** - User behavior tracking, trip events, feature usage (INSERTED) ✓
- [ ] **Phase 7: Compliance Foundation** - Privacy policy, terms of service, PrivacyInfo.xcprivacy
- [ ] **Phase 8: App Store Preparation** - Screenshots, metadata, final verification

## Phase Details

### Phase 1: Testing Infrastructure & Mocks
**Goal**: Build comprehensive test infrastructure with mock services and drive simulation before any refactoring
**Depends on**: Nothing (first phase - critical safety net)
**Research**: Likely (mocking iOS sensors, Flutter test patterns, drive simulation)
**Research topics**:
- Mocking CMMotionActivityManager in XCTest
- Mocking CLLocationManager for GPS simulation
- Flutter mocktail/mockito patterns for services
- Integration testing with mock backends
- Simulating complete drive scenarios
**Plans**: TBD

Key deliverables:

**Mock Services (Flutter):**
- MockApiService - simulate backend responses
- MockLocationService - feed GPS coordinates
- MockBluetoothService - simulate car detection
- MockBackgroundService - control trip lifecycle

**Mock Services (iOS Native):**
- MockLocationManager - GPS stream simulation
- MockMotionActivityManager - motion state injection
- MockWCSession - Watch connectivity testing

**Mock Car APIs (Backend):**
- MockAudiProvider - odometer, driving status
- MockTeslaProvider - similar mocks
- Generic mock car for testing

**Drive Simulation Framework:**
- DriveSimulator class that orchestrates a complete trip:
  1. Inject motion state (automotive)
  2. Feed GPS coordinates over time
  3. Simulate car API responses (with controllable failures)
  4. Verify webhook calls
  5. Check final trip state in Firestore
- Pre-built drive scenarios (home→office, short trip, long trip, traffic)

**Stress Test Scenarios (from plan.md issues):**

*API Failure Scenarios:*
- API returns 502/503 mid-trip → counters preserved, GPS-only fallback
- API returns is_parked=True but odometer increases → override to driving
- API returns state=unknown → don't reset parked_count
- All car APIs fail for 2+ pings → switch to GPS-only mode
- API error then recovery → counters correct

*Skip Location Scenarios:*
- Park at skip location for 10+ pings → stays paused forever
- Drive away from skip location → trip resumes
- Skip location with API errors → still pauses correctly

*Car Detection Scenarios:*
- Bluetooth identifies car but API says "parked" → Bluetooth wins
- No Bluetooth, API finds driving car → normal flow
- Bluetooth car + API odometer data → combined correctly
- No Bluetooth, no driving car found for 3 pings → trip cancelled

*Edge Cases:*
- Odometer goes backwards (bad data) → ignore, use last good value
- False trip start (motion → immediately stationary) → cancel quickly
- Stale trip (no activity 2+ hours) → safety net finalizes
- GPS coordinate format mix (lng vs lon) → handle both
- OSRM unavailable → haversine fallback with 15% correction

*Counter Threshold Tests:*
- no_driving_count hits 3 → trip cancelled
- api_error_count hits 2 → GPS-only mode triggered
- parked_count hits 3 → trip finalized
- Each counter resets correctly when condition clears

**Baseline Tests:**
- Unit tests for existing AuthService
- Unit tests for existing ApiService
- Unit tests for trip state machine (all thresholds)
- Unit tests for GPS distance calculation (OSRM + haversine)
- Integration test: complete drive simulation
- Integration test: each stress scenario above

### Phase 2: iOS Native Architecture
**Goal**: Extract focused services from monolithic AppDelegate.swift (828 lines)
**Depends on**: Phase 1 (tests catch regressions)
**Research**: Likely (iOS service patterns)
**Research topics**: Best practices for iOS service extraction, singleton vs DI patterns, background task management patterns
**Plans**: TBD

Key deliverables:
- LocationTrackingService (location manager, permissions, background updates)
- MotionActivityHandler (CMMotionActivity processing, state transitions)
- LiveActivityManager (ActivityKit, background task requests)
- WatchConnectivityService (all WCSession handling)
- AppDelegate reduced to thin coordinator (<200 lines)
- **All services have mock implementations from Phase 1**
- **Tests verify behavior unchanged after extraction**

### Phase 2.1: iOS Testing Infrastructure (INSERTED)
**Goal**: Add iOS XCTests with mock services for automated trip testing
**Depends on**: Phase 2 (protocols must exist)
**Research**: None (using established patterns from Phase 1)
**Plans**: 1

Key deliverables:
- MockLocationTrackingService - GPS coordinate injection
- MockMotionActivityHandler - Motion state simulation
- MockLiveActivityManager - Verify Live Activity calls
- MockWatchConnectivityService - Verify Watch sync
- DriveSimulator - Orchestrate complete trip scenarios
- TripLifecycleTests - XCTests for all trip behaviors
- **Run in iOS Simulator - no physical device needed**

### Phase 3: Motion Detection Hardening
**Goal**: Make trip detection more reliable with proper state machine
**Depends on**: Phase 2
**Research**: Likely (CMMotionActivity best practices)
**Research topics**: Motion activity debouncing patterns, hysteresis implementation, confidence thresholds
**Plans**: TBD

Key deliverables:
- Debouncing for motion state changes (prevent oscillation)
- Configurable confidence thresholds
- State machine documentation
- Better handling of edge cases (walk to car, car in traffic)
- **Drive simulation tests for edge cases**
- **Regression tests for all fixed scenarios**

### Phase 4: Flutter Provider Split
**Goal**: Break AppProvider (954 lines, 50+ methods) into focused providers
**Depends on**: Phase 1 (tests catch regressions)
**Research**: Unlikely (established Provider patterns)
**Plans**: TBD

Key deliverables:
- TripProvider (trip lifecycle: start, ping, end, cancel)
- CarProvider (car management, credentials, selection)
- ConnectivityProvider (Bluetooth, CarPlay, offline queue)
- SettingsProvider (app settings, preferences)
- AppProvider becomes thin orchestrator
- **Unit tests for each new provider**
- **Integration tests verify same behavior**

### Phase 5: Flutter UI Refactoring
**Goal**: Split oversized screen files into manageable components
**Depends on**: Phase 4
**Research**: Unlikely (standard Flutter patterns)
**Plans**: TBD

Key deliverables:
- cars_screen.dart (2008 lines) split into:
  - CarsListScreen (main UI)
  - CarCredentialDialog (add/edit car)
  - CarOAuthWebView (OAuth flows)
  - CarBrandSelector widget
- permission_onboarding_screen.dart (969 lines) split into:
  - OnboardingPageController
  - PermissionRequestPage widgets
  - AuthFlowPage widget
- **Widget tests for new components**

### Phase 6.1: Firestore Optimization (INSERTED/URGENT)
**Goal**: Fix critical Firestore read inefficiencies causing ~590,000 reads/day for single user
**Depends on**: Phase 5 (no code dependencies, inserted for cost urgency)
**Research**: Complete (polling vs listeners, denormalization, cursor pagination)
**Plans**: 1

Key issues fixed:
- Watch app polls every 30s with full refresh → 5-min idle, 30s lightweight during trips
- N+1 car stats query (reads ALL trips per car) → Denormalize stats into car document
- Trip pagination uses offset×3 → Cursor-based pagination

Expected impact: ~95% reduction in Firestore reads (~590K → ~5K/day)

### Phase 6: Error Handling & Logging
**Goal**: Production-grade error handling and crash reporting
**Depends on**: Phase 5
**Research**: Likely (Crashlytics setup, structured logging)
**Research topics**: Firebase Crashlytics Flutter integration, structured logging best practices, user-facing error patterns
**Plans**: TBD

Key deliverables:
- Firebase Crashlytics integration
- Structured error logging (context: user_id, trip_id)
- Consistent API retry logic across iOS native and Flutter
- User-facing error messages (not just console logs)
- Remove/guard debug print statements
- **Tests verify error scenarios handled correctly**

### Phase 6.2: Firebase Analytics (INSERTED)
**Goal**: Add analytics to understand user behavior and app usage patterns
**Depends on**: Phase 6 (Crashlytics already configured Firebase)
**Research**: Likely (Firebase Analytics Flutter integration, event design)
**Research topics**: Firebase Analytics Flutter setup, custom event design, screen tracking, user properties
**Plans**: 1

Key deliverables:
- Firebase Analytics Flutter integration (firebase_analytics package)
- Custom trip events (trip_started, trip_ended, trip_cancelled, trip_classified)
- Screen tracking (dashboard, history, settings, car management)
- User properties (car_count, total_trips, app_version)
- Consent-aware implementation (respect ATT on iOS)
- Analytics service abstraction for testability
- **Test mocks for analytics service**

### Phase 7: Compliance Foundation
**Goal**: Meet basic App Store compliance requirements
**Depends on**: Phase 6.2
**Research**: Unlikely (standard iOS/Flutter patterns)
**Plans**: TBD

Key deliverables:
- In-app privacy policy screen (link to web + inline text)
- In-app terms of service screen
- Verify PrivacyInfo.xcprivacy covers all API usage
- Version management setup (semantic versioning)
- CHANGELOG.md creation

### Phase 8: App Store Preparation
**Goal**: Complete all App Store Connect requirements
**Depends on**: All previous phases
**Research**: Unlikely (standard App Store process)
**Plans**: TBD

Key deliverables:
- App Store Connect metadata (description, keywords)
- Screenshots for all required device sizes
- Privacy practices disclosure
- Age rating questionnaire
- Final build verification checklist
- TestFlight beta testing round
- **Full drive simulation test passes**

## Progress

**Execution Order:**
Phases execute in numeric order: 1 → 2 → 3 → 4 → 5 → 6 → 7 → 8

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Testing Infrastructure & Mocks | 6/6 | Complete | 2026-01-19 |
| 2. iOS Native Architecture | 5/5 | Complete | 2026-01-19 |
| 2.1. iOS Testing Infrastructure | 1/1 | Complete | 2026-01-19 |
| 3. Motion Detection Hardening | 2/2 | Complete | 2026-01-19 |
| 4. Flutter Provider Split | 4/4 | Complete | 2026-01-19 |
| 5. Flutter UI Refactoring | 3/3 | Complete | 2026-01-19 |
| 6.1. Firestore Optimization | 1/1 | Complete | 2026-01-19 |
| 6. Error Handling & Logging | 4/4 | Complete | 2026-01-20 |
| 6.2. Firebase Analytics | 1/1 | Complete | 2026-01-20 |
| 7. Compliance Foundation | 1/TBD | In progress | - |
| 8. App Store Preparation | 0/TBD | Not started | - |
