# Roadmap: Zero Click iOS App Store Release

## Overview

Transform Zero Click from a functional personal-use app into a production-ready iOS App Store release. The journey starts with compliance requirements, then systematically addresses technical debt through iOS native refactoring, Flutter architecture improvements, and establishing test coverage.

## Domain Expertise

None (standard Flutter/Swift development patterns)

## Phases

**Phase Numbering:**
- Integer phases (1, 2, 3): Planned milestone work
- Decimal phases (2.1, 2.2): Urgent insertions (marked with INSERTED)

- [ ] **Phase 1: Compliance Foundation** - Privacy policy, terms of service, PrivacyInfo.xcprivacy
- [ ] **Phase 2: iOS Native Architecture** - Extract services from AppDelegate monolith
- [ ] **Phase 3: Motion Detection Hardening** - Fix hysteresis, debouncing, state machine reliability
- [ ] **Phase 4: Flutter Provider Split** - Break AppProvider into focused providers
- [ ] **Phase 5: Flutter UI Refactoring** - Split oversized screen files
- [ ] **Phase 6: Error Handling & Logging** - Crash reporting, structured logging, user feedback
- [ ] **Phase 7: Testing Foundation** - Unit tests for critical paths
- [ ] **Phase 8: App Store Preparation** - Screenshots, metadata, final verification

## Phase Details

### Phase 1: Compliance Foundation
**Goal**: Meet basic App Store compliance requirements
**Depends on**: Nothing (first phase)
**Research**: Unlikely (standard iOS/Flutter patterns)
**Plans**: TBD

Key deliverables:
- In-app privacy policy screen (link to web + inline text)
- In-app terms of service screen
- Verify PrivacyInfo.xcprivacy covers all API usage
- Version management setup (semantic versioning)
- CHANGELOG.md creation

### Phase 2: iOS Native Architecture
**Goal**: Extract focused services from monolithic AppDelegate.swift (828 lines)
**Depends on**: Phase 1
**Research**: Likely (iOS service patterns)
**Research topics**: Best practices for iOS service extraction, singleton vs DI patterns, background task management patterns
**Plans**: TBD

Key deliverables:
- LocationTrackingService (location manager, permissions, background updates)
- MotionActivityHandler (CMMotionActivity processing, state transitions)
- LiveActivityManager (ActivityKit, background task requests)
- WatchConnectivityService (all WCSession handling)
- AppDelegate reduced to thin coordinator (<200 lines)

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

### Phase 4: Flutter Provider Split
**Goal**: Break AppProvider (954 lines, 50+ methods) into focused providers
**Depends on**: Phase 1
**Research**: Unlikely (established Provider patterns)
**Plans**: TBD

Key deliverables:
- TripProvider (trip lifecycle: start, ping, end, cancel)
- CarProvider (car management, credentials, selection)
- ConnectivityProvider (Bluetooth, CarPlay, offline queue)
- SettingsProvider (app settings, preferences)
- AppProvider becomes thin orchestrator

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

### Phase 7: Testing Foundation
**Goal**: Establish baseline test coverage for critical flows
**Depends on**: Phase 4, Phase 5
**Research**: Unlikely (standard Flutter/Swift testing)
**Plans**: TBD

Key deliverables:
- Unit tests for AuthService (login, logout, token refresh)
- Unit tests for TripProvider (trip state machine)
- Unit tests for ApiService (error handling, retries)
- Widget tests for key screens
- Integration test for onboarding flow

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

## Progress

**Execution Order:**
Phases execute in numeric order: 1 → 2 → 3 → 4 → 5 → 6 → 7 → 8

| Phase | Plans Complete | Status | Completed |
|-------|----------------|--------|-----------|
| 1. Compliance Foundation | 0/TBD | Not started | - |
| 2. iOS Native Architecture | 0/TBD | Not started | - |
| 3. Motion Detection Hardening | 0/TBD | Not started | - |
| 4. Flutter Provider Split | 0/TBD | Not started | - |
| 5. Flutter UI Refactoring | 0/TBD | Not started | - |
| 6. Error Handling & Logging | 0/TBD | Not started | - |
| 7. Testing Foundation | 0/TBD | Not started | - |
| 8. App Store Preparation | 0/TBD | Not started | - |
