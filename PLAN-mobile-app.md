# Mobile App - Mileage Tracker (Flutter)

## Status: Phase 1 Complete ✅

The mobile app is built with **Flutter** and provides manual trip controls with offline support.

---

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     Mobile App (Flutter)                     │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │ Connection  │  │   GPS       │  │  Manual Controls    │  │
│  │ Detection   │  │   Tracking  │  │  (Start/Stop/Ping)  │  │
│  └──────┬──────┘  └──────┬──────┘  └──────────┬──────────┘  │
│         │                │                     │             │
│         └────────────────┼─────────────────────┘             │
│                          ▼                                   │
│              ┌───────────────────────┐                       │
│              │   Offline Queue       │                       │
│              │   (SharedPreferences) │                       │
│              └───────────┬───────────┘                       │
└──────────────────────────┼──────────────────────────────────┘
                           │
                           ▼
              ┌───────────────────────┐
              │   Cloud Run API       │
              │   /webhook/*          │
              └───────────────────────┘
```

---

## Tech Stack

- **Framework**: Flutter 3.x
- **Language**: Dart
- **State Management**: Provider
- **Storage**: SharedPreferences (settings, offline queue)
- **Location**: Geolocator
- **Network**: http + connectivity_plus

---

## Features Implemented ✅

### 1. Manual Trip Controls
- **Start Trip** - Sends GPS location to `/webhook/start`
- **Stop Trip** - Sends GPS location to `/webhook/end`
- **GPS Ping** - Sends current location to `/webhook/ping`
- **Finalize** - Force completes the active trip
- **Cancel** - Cancels the active trip

### 2. GPS Location
- Foreground location tracking
- Background location permissions configured
- High-accuracy GPS positioning

### 3. Offline Queue
- Queues webhook calls when offline
- Automatically processes queue when back online
- Shows queue status in UI
- Retries failed requests (max 5 times)

### 4. Trip History
- Shows recent trips from API
- Full trip list with details
- Trip type badges (Zakelijk/Privé/Gemengd)
- Route deviation warnings

### 5. Car Status
- Shows car battery level
- Charging status
- Odometer reading
- Connection state

### 6. Settings
- API URL configuration
- User email configuration
- Car Bluetooth names for detection
- Auto-detect toggle

---

## Project Structure

```
mobile/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── models/
│   │   ├── trip.dart                # Trip, Stats, ActiveTrip, CarData
│   │   └── settings.dart            # AppSettings, QueuedRequest
│   ├── providers/
│   │   └── app_provider.dart        # State management
│   ├── screens/
│   │   ├── dashboard_screen.dart    # Main dashboard
│   │   ├── history_screen.dart      # Trip history
│   │   └── settings_screen.dart     # Configuration
│   ├── services/
│   │   ├── api_service.dart         # API calls (matches web patterns)
│   │   ├── location_service.dart    # GPS tracking
│   │   └── offline_queue.dart       # Offline support
│   └── widgets/
│       ├── trip_controls.dart       # Start/Stop/Ping buttons
│       ├── active_trip_banner.dart  # Active trip indicator
│       ├── stats_cards.dart         # Statistics display
│       └── car_status_card.dart     # Car status display
├── pubspec.yaml                      # Dependencies
├── ios/                              # iOS project
└── android/                          # Android project
```

---

## Running the App

```bash
# Install dependencies
cd mobile
flutter pub get

# Run on iOS Simulator
flutter run -d ios

# Run on Android Emulator
flutter run -d android

# Run on connected device
flutter run
```

---

## Building for Release

```bash
# iOS (requires Xcode + Apple Developer account)
flutter build ios

# Android
flutter build apk
flutter build appbundle  # For Play Store
```

---

## API Integration

The app uses the same API patterns as the web frontend:

```dart
// Headers include X-User-Email for multi-tenant support
Map<String, String> get _headers => {
  'Content-Type': 'application/json',
  'X-User-Email': userEmail,
};

// Webhook calls
await api.startTrip(lat, lng);
await api.endTrip(lat, lng);
await api.sendPing(lat, lng);
await api.getStatus();
await api.finalize();
await api.cancel();

// Data calls
await api.getTrips();
await api.getStats();
await api.getCarData();
```

---

## Next Steps (Phase 2+)

### Background GPS Tracking
- [ ] Add workmanager for background tasks
- [ ] Periodic GPS pings during trips
- [ ] Battery optimization

### Automatic Car Detection
- [ ] iOS: CarPlay detection
- [ ] iOS: Bluetooth detection (CoreBluetooth)
- [ ] Android: Android Auto detection
- [ ] Android: Bluetooth detection
- [ ] Auto-trigger trip start/end

### Polish
- [ ] Push notifications for trip events
- [ ] Home screen widgets
- [ ] App icons and splash screen
- [ ] App Store / Play Store submission

---

## Configuration

### iOS (ios/Runner/Info.plist)
- Location permissions configured
- Background modes: location, fetch

### Android (android/app/src/main/AndroidManifest.xml)
- Location permissions: FINE, COARSE, BACKGROUND
- Internet permission

---

## UI Screenshots

The app has a dark theme matching the web frontend:

1. **Dashboard**: Active trip banner, controls, car status, stats, recent trips
2. **History**: Full trip list with details
3. **Settings**: API config, user email, car names
