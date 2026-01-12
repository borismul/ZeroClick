# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Autonomous mileage tracking system for Audi Q4 e-tron vehicles. Captures trip data from iPhone CarPlay automations, classifies trips as business/private, stores in Firestore, and exports to Google Sheets.

**Architecture:**
```
Mobile App (Flutter) ─┐
Watch App (SwiftUI) ──┼──→ Cloud Run API (Python/FastAPI) → Firestore ← Cloud Run Frontend (Next.js)
iPhone (CarPlay) ─────┘                                          ↓
                                                          Google Sheets (export)
```

## Build & Deploy Commands

```bash
# Deploy services (requires GCP authentication)
./deploy.sh api dev           # Deploy API only
./deploy.sh frontend dev      # Deploy frontend only
./deploy.sh all dev           # Deploy everything
./deploy.sh <service> dev --plan-only  # Plan without applying

# API local development
cd api
uv sync                       # Install dependencies
uvicorn main:app --host 0.0.0.0 --port 8080  # Run locally

# Frontend local development
cd frontend
npm install                   # Install dependencies
npm run dev                   # Dev server on port 3000
npm run build                 # Production build

# Mobile app development (Flutter)
cd mobile
flutter pub get               # Install dependencies
flutter run                   # Run on connected device
flutter build ios             # Build iOS app
flutter build apk             # Build Android app

# Deploy to Boris's iPhone
cd mobile
flutter build ios --release
xcrun devicectl device install app --device 00008120-00025D561178C01E build/ios/iphoneos/Runner.app

# Watch app development (SwiftUI)
cd watch/MileageWatch
xcodebuild -scheme MileageWatch -sdk watchos -configuration Debug -destination 'generic/platform=watchOS' build

# Deploy to Boris's Apple Watch
xcrun devicectl device install app --device B50CFEC3-1DA7-5A1B-98F0-D6AF7DE49C9B build/Products/Debug-watchos/MileageWatch.app
```

## Tech Stack

- **API**: Python 3.13, FastAPI, uv (package manager), Uvicorn
- **Frontend**: Next.js 15, React 19, TypeScript (standalone output)
- **Mobile**: Flutter 3.x, Dart, Provider (iOS + Android)
- **Watch**: SwiftUI, WatchConnectivity, watchOS 10.0+
- **Infrastructure**: Terraform with GCS backend, Google Cloud Run
- **Database**: Firestore (collections: `trips`, `locations`, `cache`)
- **Region**: europe-west4

## Key Files

- `api/main.py` - FastAPI application with all API endpoints
- `frontend/app/page.tsx` - Dashboard React component
- `mobile/lib/main.dart` - Flutter app entry point
- `mobile/lib/screens/` - Mobile app screens (dashboard, history, settings)
- `mobile/ios/Runner/AppDelegate.swift` - iOS native code, WatchConnectivity, motion detection
- `mobile/ios/Runner/KeychainHelper.swift` - iCloud Keychain sync for auth token
- `deploy.sh` - Complete deployment automation
- `api/terraform/` - API infrastructure (Cloud Run, Firestore, IAM)
- `frontend/terraform/` - Frontend infrastructure (Cloud Run, IAP)

**Watch App** (`watch/MileageWatch/`):
- `MileageWatchApp.swift` - App entry point
- `ContentView.swift` - Main view (shows LiveTripView during active trip, else TabView)
- `MileageViewModel.swift` - MVVM view model, API calls, state management
- `APIClient.swift` - API client with 401 retry and token refresh
- `WatchConnectivityManager.swift` - iPhone↔Watch communication
- `KeychainHelper.swift` - Reads auth token from iCloud Keychain
- `Models.swift` - Data models (Trip, ActiveTrip, Stats, etc.)
- `Views/LiveTripView.swift` - Full-screen workout-style view during active trip
- `Views/ActiveTripView.swift` - Status tab showing current trip
- `Views/StatsView.swift` - Totals/statistics tab
- `Views/TripsListView.swift` - Infinite scroll trips list
- `Views/TripDetailView.swift` - Trip detail with OpenStreetMap
- `Views/SettingsView.swift` - Settings tab

## API Endpoints

**Webhooks** (called by mobile app or iPhone CarPlay automations):
- `POST /webhook/start` - Trip start event
- `POST /webhook/end` - Trip end event
- `POST /webhook/ping` - GPS ping during trip
- `GET /webhook/status` - Check active trip status
- `POST /webhook/finalize` - Force complete trip
- `POST /webhook/cancel` - Cancel active trip

**Trip Management**:
- `GET/POST /trips` - List/create trips
- `GET/PATCH/DELETE /trips/{trip_id}` - Single trip operations
- `GET /stats` - Aggregate statistics

**Locations**: `GET/POST/DELETE /locations`
**Export**: `POST /export` - Export to Google Sheets
**Audi**: `GET /audi/odometer`, `GET /audi/compare`

## Environment Variables (API)

Required in `api/terraform/environments/dev.tfvars`:
- `PROJECT_ID`, `MAPS_API_KEY`
- `CONFIG_HOME_LAT/LON`, `CONFIG_OFFICE_LAT/LON`
- `CONFIG_START_ODOMETER`, `CONFIG_SKIP_LAT/LON`
- `AUDI_USERNAME/PASSWORD/COUNTRY/SPIN`

## GCP Project

- **Project ID**: `mileage-tracker-482013`
- **Region**: `europe-west4`

## Watch App

**Features:**
- Workout-style live trip screen during active driving (shows km, duration, avg speed)
- Push notification when trip starts ("Rit Gestart")
- 4-tab UI: Status → Totals → Trips → Settings (vertical page style)
- Infinite scroll trips list with pagination
- Trip detail view with OpenStreetMap integration
- Auto-refresh on app launch

**Authentication Flow:**
1. User logs in with Google Sign-In on iPhone (Flutter app)
2. Auth token saved to iCloud Keychain via `KeychainHelper` (syncs automatically)
3. Watch reads token from Keychain (instant, works offline)
4. On 401 error, Watch wakes iPhone via `WCSession.sendMessage` to get fresh token
5. Token also synced via `applicationContext` and `transferUserInfo` for redundancy

**iPhone → Watch Communication:**
- `applicationContext`: Email + API URL (persisted, read on activation)
- `transferUserInfo`: Auth token updates, trip start notifications (queued delivery)
- `sendMessage`: Real-time token requests when iPhone app is reachable

**UI Structure:**
```
ContentView
├── LiveTripView (when trip.active == true)
│   ├── Green "RIJDEN" indicator
│   ├── Large km display (64pt)
│   ├── Duration + avg speed
│   └── Red "Stop" button
└── TabView (when no active trip)
    ├── Tab 1: ActiveTripView (status)
    ├── Tab 2: StatsView (totals: zakelijk/privé/km)
    ├── Tab 3: TripsListView (infinite scroll)
    └── Tab 4: SettingsView (car selection, logout)
```

## Notes

- **Always ask before deploying** - Don't run `./deploy.sh` without user confirmation
- UI is in Dutch (Zakelijk=Business, Privé=Private, Gemengd=Mixed)
- Trip classification: automatic for home↔office routes, manual for others
- Location detection uses 150m radius (200m for skip locations)
- Terraform state stored in `gs://mileage-tracker-tfstate/`
