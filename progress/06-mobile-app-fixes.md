# Mobile App Fixes - Progress

**Story:** Bug fixes for mobile app
**Status:** Completed
**Date:** 2025-12-31

## Summary

Fixed several issues in the mobile app related to navigation and car selection.

## Issues Fixed

### 1. "Instellen" Button Not Working

**Problem:** Clicking the "Auto API niet geconfigureerd" warning button did nothing.

**Root Cause:** The app used `DefaultTabController.of(context).animateTo(2)` but the actual navigation uses `BottomNavigationBar` with `IndexedStack`, not a TabController.

**Solution:**
- Added `navigationIndex` state and `navigateTo(int)` method to `AppProvider`
- Updated `MainScreen` to use `Consumer<AppProvider>` and bind navigation to provider
- Changed all `DefaultTabController.animateTo(2)` calls to `provider.navigateTo(2)`

### 2. "Alle auto's" Option in Dropdown

**Problem:** User wanted only per-car selection, not "All cars" option.

**Solution:**
- Removed "Alle auto's" option from `CarSelector` dropdown
- Removed "Alle auto's" option from `CarSelectorCompact` popup menu
- Changed hint text to "Selecteer auto"
- Updated `selectCar(Car)` to require a non-null car

### 3. Outdated "API niet geconfigureerd" Warning

**Problem:** Warning showed even when Audi credentials were configured.

**Root Cause:** Warning checked `provider.settings.carUsername` which is the old global setting. With multi-car support, credentials are now stored per-car on the server.

**Solution:** Removed the outdated warning entirely from `DashboardScreen`.

## Files Changed

### `lib/providers/app_provider.dart`
- Added `_navigationIndex` state variable
- Added `navigationIndex` getter
- Added `navigateTo(int index)` method
- Changed `selectCar(Car? car)` to `selectCar(Car car)` (non-nullable)

### `lib/main.dart`
- Removed local `_currentIndex` state
- Changed to use `Consumer<AppProvider>` for navigation
- Bound `BottomNavigationBar` to `provider.navigationIndex` and `provider.navigateTo`

### `lib/screens/dashboard_screen.dart`
- Changed `_buildSetupPrompt(context)` to `_buildSetupPrompt(context, provider)`
- Updated navigation calls to use `provider.navigateTo(2)`
- Removed outdated "Auto API niet geconfigureerd" warning

### `lib/widgets/car_selector.dart`
- Removed "Alle auto's" option from `CarSelector` dropdown
- Removed "Alle auto's" option from `CarSelectorCompact` popup
- Updated hint text to "Selecteer auto"
- Simplified `onChanged` and `onSelected` handlers

## Technical Notes

### Navigation Architecture

Before:
```dart
// main.dart - local state, not accessible from children
int _currentIndex = 0;
onTap: (index) => setState(() => _currentIndex = index)

// dashboard_screen.dart - tried to use TabController (wrong!)
DefaultTabController.of(context).animateTo(2);
```

After:
```dart
// app_provider.dart - centralized navigation state
int _navigationIndex = 0;
void navigateTo(int index) {
  _navigationIndex = index;
  notifyListeners();
}

// main.dart - uses provider
currentIndex: provider.navigationIndex,
onTap: provider.navigateTo,

// dashboard_screen.dart - correct!
provider.navigateTo(2);
```

### Car Selection

The app now always requires a car to be selected:
- Auto-selects default car (or first car) on startup via `refreshCars()`
- Dropdown only shows individual cars, no "All" option
- `selectCar()` now takes non-nullable `Car` parameter
