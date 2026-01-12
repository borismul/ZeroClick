# Mobile App Refactoring Plan

## Status: PENDING

**Date:** 2026-01-09
**Current SDK:** Dart ^3.7.0, Flutter 3.x
**Target:** Modern Flutter architecture with latest dependencies

---

## Executive Summary

The mobile app is functional but has accumulated technical debt:
- **8 outdated dependencies** (some with breaking changes)
- **2 deprecated APIs** in active use
- **1 God Object** (871-line AppProvider)
- **No HTTP error handling** in ApiService
- **Mixed architecture patterns** (Provider + callbacks + singletons)
- **Hardcoded strings** in UI (Dutch text not using l10n)
- **No unit tests** (only widget_test.dart placeholder)

---

## 1. Dependency Audit

### Critical Updates (Breaking Changes)

| Package | Current | Latest | Breaking Changes |
|---------|---------|--------|------------------|
| `google_sign_in` | ^6.2.1 | **7.2.0** | Major API restructure - requires migration guide |
| `shared_preferences` | ^2.5.4 | 2.5.4 | Legacy API deprecated, migrate to `SharedPreferencesAsync` |
| `webview_flutter` | ^4.13.0 | **4.13.1** | Minor (already on v4 architecture) |

### Recommended Updates (Non-Breaking)

| Package | Current | Latest | Notes |
|---------|---------|--------|-------|
| `provider` | ^6.1.5 | **6.1.5+1** | Patch release |
| `http` | ^1.6.0 | 1.6.0 | Current |
| `connectivity_plus` | ^7.0.0 | 7.0.0 | Current |
| `geolocator` | ^14.0.2 | 14.0.2 | Current |
| `permission_handler` | ^12.0.1 | 12.0.1 | Current |
| `flutter_map` | ^8.2.2 | 8.2.2 | Current |
| `sqflite` | ^2.4.2 | 2.4.2 | Current |
| `live_activities` | ^2.4.3 | **2.4.5** | Minor update |
| `url_launcher` | ^6.3.2 | 6.3.2 | Current |
| `intl` | ^0.20.2 | 0.20.2 | Current |
| `latlong2` | ^0.9.1 | 0.9.1 | Current |
| `cupertino_icons` | ^1.0.8 | 1.0.8 | Current |
| `path` | ^1.9.1 | 1.9.1 | Current |
| `flutter_lints` | ^6.0.0 | 6.0.0 | Current |
| `flutter_launcher_icons` | ^0.14.4 | 0.14.4 | Current |

### Deprecated APIs in Use

1. **SharedPreferences legacy API** (`lib/providers/app_provider.dart:341`, `lib/services/offline_queue.dart:33`)
   - `SharedPreferences.getInstance()` → `SharedPreferencesAsync`

2. **google_sign_in v6 patterns** (`lib/services/auth_service.dart`)
   - Entire auth flow needs migration to v7 API

---

## 2. Code Quality Issues

### 2.1 God Object: AppProvider (871 lines)

**Location:** `lib/providers/app_provider.dart`

**Problems:**
- Single class handles: auth, trips, cars, stats, connectivity, bluetooth, carplay, navigation, offline queue
- 25+ state variables
- 50+ methods
- Violates Single Responsibility Principle

**Solution:** Split into focused providers:
```
providers/
├── auth_provider.dart        # Authentication state
├── trip_provider.dart        # Active trip + trip CRUD
├── car_provider.dart         # Multi-car management
├── stats_provider.dart       # Statistics
├── connectivity_provider.dart # Online/offline + queue
├── device_provider.dart      # Bluetooth + CarPlay
└── navigation_provider.dart  # Tab navigation
```

### 2.2 No HTTP Error Handling

**Location:** `lib/services/api_service.dart`

**Problems:**
- No response status checking on most endpoints (lines 41-68)
- Silent failures (jsonDecode on error responses)
- No retry logic
- No timeout configuration
- Inconsistent error throwing

**Example of bad pattern (line 41-47):**
```dart
Future<Map<String, dynamic>> startTrip(...) async {
  final response = await http.post(...);
  return jsonDecode(response.body);  // No status check!
}
```

**Solution:** Implement proper HTTP client wrapper with:
- Response status validation
- Typed error classes
- Retry with exponential backoff
- Request/response logging
- Timeout configuration

### 2.3 Singleton Anti-Pattern

**Locations:**
- `AuthService` (line 6-9): Singleton with mutable state
- Services instantiated in provider constructor without DI

**Problems:**
- Tight coupling
- Hard to test
- State persists across tests

**Solution:** Use dependency injection via `Provider` or `get_it`

### 2.4 Mixed State Patterns

**Current patterns in use:**
1. Provider/ChangeNotifier (AppProvider)
2. Callbacks (CarDetectedCallback, etc.)
3. Singletons (AuthService)
4. Direct service instantiation

**Solution:** Standardize on Provider + Repository pattern

### 2.5 Hardcoded Dutch Strings

**Locations:**
- `lib/main.dart:148-181` - Welcome dialog
- `lib/providers/app_provider.dart:333,703,770-777` - Error messages
- `lib/screens/settings_screen.dart:243-275` - Setup tip card

**Solution:** Move all strings to ARB files

### 2.6 Print Statements in Production Code

**Count:** 40+ `print()` calls across codebase

**Locations:**
- `app_provider.dart`: 15+ print statements
- `background_service.dart`: 12+ print statements
- `api_service.dart`: 3+ print statements

**Solution:** Replace with proper logging (`package:logging` or custom)

### 2.7 No Type Safety in l10n Usage

**Example (trip.dart:104):**
```dart
String getDistanceSourceLabel(dynamic l10n) {  // dynamic!
```

**Solution:** Use proper `AppLocalizations` type

### 2.8 Weak ID Generation

**Location:** `lib/services/offline_queue.dart:118-121`
```dart
String _generateId() {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  return List.generate(9, (i) => chars[(DateTime.now().microsecond + i) % chars.length]).join();
}
```

**Problems:**
- Not cryptographically random
- Predictable pattern
- Collision risk

**Solution:** Use `package:uuid` or `Random.secure()`

### 2.9 Missing Dispose Patterns

**Location:** `app_provider.dart`
- Connectivity subscription never disposed
- Service callbacks never cleaned up

### 2.10 No Input Validation

**Location:** `api_service.dart` - User input passed directly to URLs without validation

---

## 3. Architecture Improvements

### 3.1 Current Architecture

```
┌─────────────────────────────────────────────┐
│                    UI                        │
│  (Screens consume AppProvider directly)      │
└─────────────────┬───────────────────────────┘
                  │
┌─────────────────▼───────────────────────────┐
│            AppProvider (871 lines)           │
│  - All state                                 │
│  - All business logic                        │
│  - Direct service calls                      │
└─────────────────┬───────────────────────────┘
                  │
┌─────────────────▼───────────────────────────┐
│              Services                        │
│  - ApiService (no error handling)            │
│  - AuthService (singleton)                   │
│  - BackgroundService                         │
│  - LocationService                           │
│  - OfflineQueue                              │
└─────────────────────────────────────────────┘
```

### 3.2 Target Architecture

```
┌─────────────────────────────────────────────┐
│                    UI                        │
│  (Screens with Consumer widgets)             │
└─────────────────┬───────────────────────────┘
                  │
┌─────────────────▼───────────────────────────┐
│              Providers                       │
│  - AuthProvider                              │
│  - TripProvider                              │
│  - CarProvider                               │
│  - StatsProvider                             │
│  - ConnectivityProvider                      │
│  - DeviceProvider                            │
└─────────────────┬───────────────────────────┘
                  │
┌─────────────────▼───────────────────────────┐
│            Repositories                      │
│  - TripRepository                            │
│  - CarRepository                             │
│  - StatsRepository                           │
│  - AuthRepository                            │
└─────────────────┬───────────────────────────┘
                  │
┌─────────────────▼───────────────────────────┐
│          Data Sources                        │
│  - ApiClient (with proper error handling)    │
│  - LocalStorage (SharedPreferencesAsync)     │
│  - NativeBridge (MethodChannel)              │
└─────────────────────────────────────────────┘
```

### 3.3 New Directory Structure

```
lib/
├── main.dart
├── app.dart                    # MaterialApp configuration
├── l10n/                       # (keep existing)
│
├── core/                       # Shared infrastructure
│   ├── api/
│   │   ├── api_client.dart     # HTTP client with error handling
│   │   ├── api_exception.dart  # Typed exceptions
│   │   └── api_endpoints.dart  # Endpoint constants
│   ├── storage/
│   │   ├── local_storage.dart  # SharedPreferencesAsync wrapper
│   │   └── secure_storage.dart # Keychain wrapper
│   ├── native/
│   │   ├── native_bridge.dart  # MethodChannel abstraction
│   │   └── native_methods.dart # Method name constants
│   └── logging/
│       └── app_logger.dart     # Logging utility
│
├── features/                   # Feature modules
│   ├── auth/
│   │   ├── data/
│   │   │   └── auth_repository.dart
│   │   ├── domain/
│   │   │   └── auth_state.dart
│   │   └── presentation/
│   │       ├── auth_provider.dart
│   │       └── widgets/
│   │
│   ├── trips/
│   │   ├── data/
│   │   │   └── trip_repository.dart
│   │   ├── domain/
│   │   │   ├── trip.dart
│   │   │   ├── active_trip.dart
│   │   │   └── gps_point.dart
│   │   └── presentation/
│   │       ├── trip_provider.dart
│   │       ├── screens/
│   │       │   ├── dashboard_screen.dart
│   │       │   ├── history_screen.dart
│   │       │   ├── trip_detail_screen.dart
│   │       │   ├── trip_edit_screen.dart
│   │       │   └── trip_map_screen.dart
│   │       └── widgets/
│   │           ├── trip_controls.dart
│   │           ├── active_trip_banner.dart
│   │           └── stats_cards.dart
│   │
│   ├── cars/
│   │   ├── data/
│   │   │   └── car_repository.dart
│   │   ├── domain/
│   │   │   ├── car.dart
│   │   │   └── car_data.dart
│   │   └── presentation/
│   │       ├── car_provider.dart
│   │       ├── screens/
│   │       │   └── cars_screen.dart
│   │       └── widgets/
│   │           ├── car_selector.dart
│   │           └── car_status_card.dart
│   │
│   ├── charging/
│   │   └── presentation/
│   │       └── screens/
│   │           └── charging_map_screen.dart
│   │
│   ├── settings/
│   │   ├── data/
│   │   │   └── settings_repository.dart
│   │   ├── domain/
│   │   │   └── app_settings.dart
│   │   └── presentation/
│   │       └── screens/
│   │           └── settings_screen.dart
│   │
│   └── connectivity/
│       ├── data/
│       │   └── offline_queue_repository.dart
│       └── presentation/
│           └── connectivity_provider.dart
│
└── shared/                     # Shared widgets & utilities
    ├── widgets/
    │   └── device_link_dialog.dart
    └── utils/
        └── color_utils.dart
```

---

## 4. Refactoring Phases

### Phase 1: Foundation (No Functionality Changes)

**Objective:** Set up infrastructure without changing behavior

1. **Update analysis_options.yaml**
   - Enable strict mode
   - Add recommended lints
   - Enable `avoid_print` rule

2. **Create core infrastructure**
   - `core/api/api_client.dart` - HTTP client with error handling
   - `core/api/api_exception.dart` - Typed exceptions
   - `core/logging/app_logger.dart` - Replace print statements
   - `core/storage/local_storage.dart` - SharedPreferencesAsync wrapper

3. **Add tests infrastructure**
   - Set up test directory structure
   - Add mockito/mocktail dependency
   - Create test utilities

**Files to create:**
- `lib/core/api/api_client.dart`
- `lib/core/api/api_exception.dart`
- `lib/core/logging/app_logger.dart`
- `lib/core/storage/local_storage.dart`
- `test/core/api/api_client_test.dart`

### Phase 2: Dependency Updates

**Objective:** Update to latest stable versions

1. **Update google_sign_in to v7**
   - Follow migration guide
   - Update `auth_service.dart`
   - Test on device

2. **Migrate SharedPreferences to async API**
   - Replace `getInstance()` with `SharedPreferencesAsync`
   - Update all storage calls

3. **Update live_activities to 2.4.5**

4. **Update pubspec.yaml**
   ```yaml
   dependencies:
     google_sign_in: ^7.2.0
     live_activities: ^2.4.5
   ```

### Phase 3: ApiService Refactor

**Objective:** Proper HTTP handling

1. **Create ApiClient with:**
   - Base URL configuration
   - Auth header injection
   - Response status validation
   - Typed error responses
   - Timeout configuration
   - Request logging

2. **Create ApiException types:**
   - `NetworkException`
   - `UnauthorizedException`
   - `ValidationException`
   - `ServerException`

3. **Migrate ApiService endpoints** to use new client

4. **Add retry logic** for transient failures

### Phase 4: Split AppProvider

**Objective:** Single responsibility providers

1. **Extract AuthProvider**
   - Auth state
   - Sign in/out
   - Token management

2. **Extract TripProvider**
   - Active trip state
   - Trip CRUD
   - Webhook operations

3. **Extract CarProvider**
   - Car list
   - Selected car
   - Car data

4. **Extract ConnectivityProvider**
   - Online/offline state
   - Queue management

5. **Extract DeviceProvider**
   - Bluetooth state
   - CarPlay state

6. **Update UI** to use MultiProvider

### Phase 5: Localization Cleanup

**Objective:** All user-facing text in ARB files

1. **Audit hardcoded strings**
2. **Add missing ARB entries**
3. **Update components** to use l10n
4. **Fix dynamic l10n types** to `AppLocalizations`

### Phase 6: Code Quality

**Objective:** Production-ready code

1. **Replace print with logger**
2. **Add dispose patterns** to providers
3. **Fix ID generation** with UUID
4. **Add input validation**
5. **Remove singleton anti-pattern** from AuthService

### Phase 7: Testing

**Objective:** Comprehensive test coverage

1. **Unit tests for:**
   - ApiClient
   - Repositories
   - Providers
   - Models

2. **Widget tests for:**
   - Key screens
   - Reusable widgets

3. **Integration tests for:**
   - Auth flow
   - Trip lifecycle

---

## 5. Risk Mitigation

### High Risk Changes

| Change | Risk | Mitigation |
|--------|------|------------|
| google_sign_in v7 migration | Auth may break | Test on device before merge |
| AppProvider split | State sync issues | Incremental extraction with tests |
| SharedPreferences migration | Data loss | Migration script + backup |

### Testing Strategy

1. **Before each phase:** Snapshot current behavior with tests
2. **During refactor:** Run tests continuously
3. **After phase:** Manual smoke test on device

### Rollback Plan

- Each phase in separate PR
- Feature flags for major changes
- Keep old code paths until validated

---

## 6. Success Metrics

| Metric | Current | Target |
|--------|---------|--------|
| Largest file (lines) | 871 (AppProvider) | <300 |
| Outdated dependencies | 3 | 0 |
| Deprecated API usage | 2 | 0 |
| Print statements | 40+ | 0 |
| Test coverage | ~0% | >60% |
| Hardcoded strings | 10+ | 0 |

---

## 7. Estimated Effort

| Phase | Complexity | Files Affected |
|-------|------------|----------------|
| Phase 1: Foundation | Medium | 5 new files |
| Phase 2: Dependencies | High | 3 files |
| Phase 3: ApiService | Medium | 2 files |
| Phase 4: Split Provider | High | 15+ files |
| Phase 5: Localization | Low | 10 files |
| Phase 6: Code Quality | Medium | 20 files |
| Phase 7: Testing | High | 20+ new files |

---

## 8. Dependencies to Add

```yaml
dev_dependencies:
  # Testing
  mocktail: ^1.0.4

dependencies:
  # Proper UUID generation
  uuid: ^4.5.1

  # Logging (optional, can use custom)
  logging: ^1.3.0
```

---

## 9. Files Summary

### Files to Create (Phase 1-6)

```
lib/core/api/api_client.dart
lib/core/api/api_exception.dart
lib/core/api/api_endpoints.dart
lib/core/logging/app_logger.dart
lib/core/storage/local_storage.dart
lib/core/native/native_bridge.dart
lib/features/auth/presentation/auth_provider.dart
lib/features/trips/presentation/trip_provider.dart
lib/features/cars/presentation/car_provider.dart
lib/features/connectivity/presentation/connectivity_provider.dart
lib/features/connectivity/data/offline_queue_repository.dart
```

### Files to Heavily Modify

```
lib/providers/app_provider.dart → Split into 5 providers
lib/services/api_service.dart → Use new ApiClient
lib/services/auth_service.dart → google_sign_in v7 migration
lib/services/offline_queue.dart → SharedPreferencesAsync
lib/main.dart → MultiProvider setup
lib/screens/*.dart → Update provider consumption
```

### Files to Delete (After Migration)

```
lib/providers/app_provider.dart (after full split)
```

---

## Next Steps

1. Review and approve this plan
2. Create feature branch `refactor/mobile-architecture`
3. Begin Phase 1: Foundation
4. PR per phase for incremental review
