# Architecture

**Analysis Date:** 2026-01-12

## Pattern Overview

**Overall:** Distributed Multi-Platform Microservices (Hybrid Monolith)

**Key Characteristics:**
- Backend: FastAPI monolith handling business logic
- Frontend: Next.js standalone dashboard
- Mobile Apps: Flutter (iOS/Android) and SwiftUI (Apple Watch)
- Event-driven: iPhone Shortcuts/CarPlay automations → Cloud Run API → Firestore
- Client-heavy architecture with centralized Python API as single source of truth

## Layers

**Auth Layer** (`api/auth/`):
- Purpose: Token validation and user identity extraction
- Contains: `middleware.py` (Bearer token validation), `dependencies.py` (FastAPI DI), `google.py` (Google OAuth verification)
- Depends on: `config.py` for client IDs
- Used by: All protected routes via middleware

**Routes Layer** (`api/routes/`):
- Purpose: HTTP endpoint definitions and request/response handling
- Contains: `trips.py`, `cars.py`, `webhooks.py`, `stats.py`, `charging.py`, `oauth/`
- Depends on: Services layer, Auth dependencies
- Used by: FastAPI app router

**Services Layer** (`api/services/`):
- Purpose: Core business logic
- Contains: `trip_service.py`, `car_service.py`, `location_service.py`, `webhook_service.py`, `export_service.py`
- Depends on: Database layer, Car providers, Utils
- Used by: Route handlers

**Car Providers Layer** (`api/car_providers/`):
- Purpose: Pluggable brand-specific car API integrations
- Contains: `base.py` (abstract), `audi.py`, `renault.py`, `tesla.py`, `vwgroup.py`, `skoda.py`
- Depends on: External car APIs
- Used by: CarService

**Models Layer** (`api/models/`):
- Purpose: Pydantic data validation models
- Contains: `trip.py`, `car.py`, `location.py`, `auth.py`, `export.py`
- Depends on: Pydantic
- Used by: Routes, Services

**Database Layer** (`api/database.py`):
- Purpose: Firestore client initialization and trip cache operations
- Contains: `get_db()`, trip cache CRUD, location loading
- Depends on: Google Cloud Firestore
- Used by: Services

## Data Flow

**Trip Tracking (Webhook → Completion):**

1. iPhone Shortcut triggers (CarPlay connected)
2. POST /webhook/start → AuthMiddleware (skip - public prefix)
3. WebhookService.handle_start() → LocationService.reverse_geocode()
4. Set trip_cache in Firestore → Return status
5. [Trip in progress] POST /webhook/ping → Update gps_trail
6. POST /webhook/end (Bluetooth disconnected)
7. WebhookService.handle_end() → CarService.get_car_data() (fetch odometer)
8. TripService.finalize_trip() → Calculate km, route deviation
9. Save to Firestore /trips → Clear trip_cache
10. Clients poll GET /trips → Display updated data

**State Management:**
- API: Stateless - Firestore trip_cache survives cold starts
- Mobile: Provider pattern with ChangeNotifier
- Watch: MVVM with ObservableObject
- Frontend: React hooks (useState, useEffect)

## Key Abstractions

**CarProvider:**
- Purpose: Abstract interface for car brand APIs
- Examples: `AudiProvider`, `RenaultProvider`, `TeslaProvider`, `VWGroupProvider`
- Pattern: Strategy pattern with `connect()`, `get_data()`, `disconnect()`, `get_odometer()`
- Location: `api/car_providers/base.py`

**Service Singleton:**
- Purpose: Business logic encapsulation
- Examples: `trip_service`, `car_service`, `webhook_service`
- Pattern: Module-level singleton instantiation
- Location: `api/services/*.py`

**AppProvider (Mobile):**
- Purpose: Central state management for Flutter app
- Pattern: ChangeNotifier with Provider
- Location: `mobile/lib/providers/app_provider.dart`

**MileageViewModel (Watch):**
- Purpose: MVVM state container for watch app
- Pattern: ObservableObject with @Published properties
- Location: `watch/MileageWatch/MileageWatch/MileageViewModel.swift`

## Entry Points

**API:**
- Location: `api/main.py`
- Triggers: HTTP requests to Cloud Run
- Responsibilities: FastAPI app, CORS, auth middleware, router composition

**Frontend:**
- Location: `frontend/app/layout.tsx` → `frontend/app/page.tsx`
- Triggers: Browser navigation
- Responsibilities: Root layout, main dashboard, NextAuth provider

**Mobile (iOS/Android):**
- Location: `mobile/lib/main.dart`
- Triggers: App launch
- Responsibilities: App initialization, theme, 4-tab navigation

**Watch (watchOS):**
- Location: `watch/MileageWatch/MileageWatch/MileageWatchApp.swift`
- Triggers: Watch app launch, complications
- Responsibilities: Environment injection, root view selection

## Error Handling

**Strategy:** Throw exceptions, catch at boundaries, return HTTP errors

**Patterns:**
- Routes catch service exceptions, return HTTPException
- Services throw ValueError/custom exceptions with descriptive messages
- Middleware handles auth failures with 401 responses
- Mobile: Offline queue for failed requests

## Cross-Cutting Concerns

**Logging:**
- API: Python logging module (`logger = logging.getLogger(__name__)`)
- Mobile: AppLogger utility (`mobile/lib/core/logging/`)
- Watch: print() statements (should be improved)

**Validation:**
- API: Pydantic models at request boundary
- Mobile: Dart strong typing with strict analysis options

**Authentication:**
- Google OAuth 2.0 via Bearer tokens
- NextAuth.js for frontend sessions
- iCloud Keychain for mobile/watch token storage
- Public paths exempted in AuthMiddleware

**State Synchronization:**
- WatchConnectivity for iPhone ↔ Watch sync
- applicationContext, transferUserInfo, sendMessage patterns

---

*Architecture analysis: 2026-01-12*
*Update when major patterns change*
