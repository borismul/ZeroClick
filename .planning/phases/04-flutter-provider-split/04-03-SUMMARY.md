---
phase: 04-flutter-provider-split
plan: 03
subsystem: state-management
tags: [flutter, provider, connectivity, bluetooth, carplay, offline-queue, dart]

# Dependency graph
requires:
  - phase: 04-02
    provides: CarProvider extraction pattern, shared ApiService instance
provides:
  - ConnectivityProvider with Bluetooth, CarPlay, network state, and offline queue
  - Cross-provider callback pattern for auto-start triggers
  - Updated provider tree: SettingsProvider -> ApiService -> CarProvider -> ConnectivityProvider -> AppProvider
affects: [04-04-trip-provider, 04-05-stats-provider]

# Tech tracking
tech-stack:
  added: []
  patterns:
    - Cross-provider callbacks for event-driven communication
    - ChangeNotifierProxyProvider2 for dual dependencies
    - ChangeNotifierProxyProvider4 for quad dependencies

key-files:
  created:
    - mobile/lib/providers/connectivity_provider.dart
  modified:
    - mobile/lib/providers/app_provider.dart
    - mobile/lib/main.dart

key-decisions:
  - "Use callback pattern (onCarPlayConnected, onBluetoothDeviceConnected) for cross-provider communication"
  - "Keep auto-start trip logic in AppProvider since it orchestrates multiple providers"
  - "ConnectivityProvider calls init() immediately after construction via cascade operator"

patterns-established:
  - "Callback pattern: ConnectivityProvider exposes callbacks, AppProvider wires them to its methods"
  - "Service ownership: Provider owns services it directly uses (ConnectivityProvider owns bluetooth, carplay, offlineQueue)"
  - "Delegation methods: AppProvider keeps processQueue() for backward compatibility, delegates to ConnectivityProvider"

issues-created: []

# Metrics
duration: ~12min
completed: 2026-01-19
---

# Phase 04-03: ConnectivityProvider Extraction Summary

**ConnectivityProvider extracted with Bluetooth, CarPlay, network state, and offline queue - enabling cross-provider callbacks for auto-start triggers**

## Performance

- **Duration:** ~12 min
- **Started:** 2026-01-19
- **Completed:** 2026-01-19
- **Tasks:** 3
- **Files modified:** 3

## Accomplishments

- Created ConnectivityProvider with 184 lines of focused connectivity logic
- Reduced AppProvider by ~100 lines (753 -> 652 lines)
- Established cross-provider callback pattern for CarPlay/Bluetooth events
- Updated provider tree to support 4 dependencies for AppProvider

## Task Commits

Each task was committed atomically:

1. **Task 1: Create ConnectivityProvider** - `af0665b` (refactor)
   - Bluetooth, CarPlay service management and listeners
   - Network connectivity state and listeners
   - Offline queue management (add, process, refresh)
   - Cross-provider callbacks: onCarPlayConnected, onBluetoothDeviceConnected, onUnknownDevice

2. **Task 2: Update AppProvider to delegate** - `8511ef3` (refactor)
   - Added ConnectivityProvider as constructor dependency
   - Removed connectivity state fields and services
   - Added delegating getters and methods
   - Set up cross-provider callbacks in _init()

3. **Task 3: Update provider tree** - `82428f8` (refactor)
   - Added ConnectivityProvider to MultiProvider
   - Used ChangeNotifierProxyProvider2 for ConnectivityProvider
   - Used ChangeNotifierProxyProvider4 for AppProvider
   - Call init() on creation via cascade operator

## Files Created/Modified

- `mobile/lib/providers/connectivity_provider.dart` - New provider managing Bluetooth, CarPlay, network, and queue (184 lines)
- `mobile/lib/providers/app_provider.dart` - Removed connectivity logic, added delegation (-100 lines net)
- `mobile/lib/main.dart` - Updated provider tree with ConnectivityProvider

## Decisions Made

1. **Cross-provider callbacks**: Instead of direct provider references, ConnectivityProvider exposes callbacks that AppProvider sets. This keeps providers loosely coupled while enabling coordination.

2. **Service ownership**: ConnectivityProvider owns BluetoothService, CarPlayService, and OfflineQueue. AppProvider no longer creates these services.

3. **Trip logic stays in AppProvider**: _tryAutoStartTrip(), _syncCarIdToNative(), and linkDeviceAndStartTrip() remain in AppProvider because they orchestrate trip lifecycle across multiple providers.

4. **Backward compatibility**: AppProvider keeps processQueue() and clearPendingUnknownDevice() as delegation methods so existing UI code continues working.

## Deviations from Plan

None - plan executed exactly as written

## Issues Encountered

None

## Next Phase Readiness

- ConnectivityProvider fully operational
- Cross-provider callback pattern established for future use
- Provider tree supports up to 4 dependencies via ChangeNotifierProxyProvider4
- Ready for TripProvider extraction (04-04) which will extract trip state and webhook methods

---
*Phase: 04-flutter-provider-split*
*Plan: 03*
*Completed: 2026-01-19*
