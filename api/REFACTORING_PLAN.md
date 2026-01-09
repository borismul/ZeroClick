# API Refactoring Plan

## Executive Summary

The current `api/main.py` is a **4,185-line monolithic file** containing all API logic. This plan describes a complete refactor into a clean, modular architecture **without breaking any existing functionality**.

---

## Current State Analysis

### File: `api/main.py` - 4,185 lines

| Section | Lines | Description |
|---------|-------|-------------|
| Auth logic | 1-165 | Google OAuth, middleware, dependencies |
| Config | 179-205 | Environment variables, CONFIG dict |
| Database/cache | 207-290 | Firestore client, trip cache |
| Pydantic models | 291-425 | 15+ models (Trip, Car, etc.) |
| Car credentials | 426-655 | Per-car credential helpers |
| Webhook endpoints | 657-1100 | /webhook/* (6 endpoints) |
| Trip finalization | 1103-1175 | Legacy finalize_trip helper |
| Trip endpoints | 1176-1600 | CRUD trips, locations |
| Stats & export | 1602-1780 | Stats, Google Sheets export |
| Helper functions | 1782-2200 | Geocoding, distance calc, GPS |
| Car CRUD | 2206-2500 | /cars/* endpoints |
| Tesla OAuth | 2480-2565 | Tesla auth flow |
| Car data | 2619-2856 | Live car data endpoint |
| Car helpers | 2896-2950 | get_default_car_id, etc. |
| Audi OAuth | 3009-3215 | Audi PKCE auth flow |
| VW Group OAuth | 3217-3460 | VW/Skoda/SEAT/CUPRA auth |
| Renault OAuth | 3462-3720 | Gigya-based auth |
| Safety net | 3723-4010 | Stale trip recovery |
| Odometer compare | 4012-4110 | /audi/compare endpoint |
| Charging stations | 4110-4180 | Open Charge Map integration |

### Existing Good Patterns (Keep)
- `car_providers/` module with abstract base class (`CarProvider`)
- Proper use of FastAPI dependencies
- Pydantic models for validation
- Firestore as database

### Problems
1. **Single 4,185-line file** - impossible to navigate
2. **Mixed concerns** - auth, routes, services, models all together
3. **Duplicated logic** - same patterns repeated (e.g., user ID extraction)
4. **No separation** - business logic mixed with HTTP handling
5. **Hard to test** - no clear service layer
6. **Import at wrong level** - imports scattered throughout file

---

## Target Architecture

```
api/
├── main.py                    # FastAPI app initialization only (~50 lines)
├── config.py                  # Configuration and environment variables
├── database.py                # Firestore client and base operations
│
├── models/                    # Pydantic models
│   ├── __init__.py
│   ├── trip.py               # Trip, TripUpdate, TripEvent, GpsPoint
│   ├── car.py                # Car, CarCreate, CarUpdate, CarCredentials
│   ├── location.py           # WebhookLocation, CustomLocation
│   └── export.py             # ExportRequest
│
├── auth/                      # Authentication
│   ├── __init__.py
│   ├── google.py             # Google OAuth verification
│   ├── middleware.py         # AuthMiddleware
│   └── dependencies.py       # get_current_user, get_user_from_header
│
├── services/                  # Business logic (no HTTP)
│   ├── __init__.py
│   ├── trip_service.py       # Trip CRUD, finalization, classification
│   ├── car_service.py        # Car management, credential helpers
│   ├── location_service.py   # Geocoding, distance calculation
│   ├── export_service.py     # Google Sheets export
│   └── webhook_service.py    # Trip tracking state machine
│
├── routes/                    # FastAPI routers (HTTP layer only)
│   ├── __init__.py
│   ├── auth.py               # /auth/* endpoints
│   ├── trips.py              # /trips/* endpoints
│   ├── cars.py               # /cars/* endpoints
│   ├── locations.py          # /locations/* endpoints
│   ├── webhooks.py           # /webhook/* endpoints
│   ├── stats.py              # /stats, /export endpoints
│   ├── oauth/                # OAuth flows
│   │   ├── __init__.py
│   │   ├── audi.py           # /audi/auth/* endpoints
│   │   ├── tesla.py          # /cars/{id}/tesla/* endpoints
│   │   ├── vwgroup.py        # /vwgroup/auth/* endpoints
│   │   └── renault.py        # /renault/auth/* endpoints
│   └── charging.py           # /charging/* endpoints
│
├── utils/                     # Pure utility functions
│   ├── __init__.py
│   ├── geo.py                # haversine, GPS calculations
│   ├── routing.py            # OSRM integration
│   └── ids.py                # ID generation
│
└── car_providers/             # (Keep existing - already modular)
    ├── __init__.py
    ├── base.py
    ├── audi.py
    ├── tesla.py
    ├── vwgroup.py
    ├── skoda.py
    └── renault.py
```

---

## Refactoring Steps

### Phase 1: Foundation (No Breaking Changes)

#### Step 1.1: Create `config.py`
Extract all configuration into a dedicated module:
- Environment variable loading
- CONFIG dict
- Constants (STALE_TRIP_HOURS, GPS_STATIONARY_TIMEOUT_MINUTES, etc.)
- OAuth configurations (VW_GROUP_OAUTH_CONFIG, RENAULT_GIGYA_CONFIG)

```python
# api/config.py
import os

class Settings:
    PROJECT_ID = os.environ.get("PROJECT_ID")
    MAPS_API_KEY = os.environ.get("MAPS_API_KEY")
    AUTH_ENABLED = os.environ.get("AUTH_ENABLED", "false").lower() == "true"

    # Google OAuth Client IDs
    GOOGLE_CLIENT_IDS = [
        cid for cid in [
            os.environ.get("GOOGLE_OAUTH_CLIENT_ID", ""),
            os.environ.get("GOOGLE_WEB_CLIENT_ID", ""),
            os.environ.get("GOOGLE_IOS_CLIENT_ID", ""),
        ] if cid
    ]

    # Locations config
    HOME_LAT = float(os.environ.get("CONFIG_HOME_LAT", 0))
    HOME_LON = float(os.environ.get("CONFIG_HOME_LON", 0))
    # ... etc

settings = Settings()
```

#### Step 1.2: Create `database.py`
Extract Firestore client and base operations:
- `get_db()` function
- Trip cache functions (`get_trip_cache`, `set_trip_cache`, `get_all_active_trips`)
- `load_custom_locations()`

#### Step 1.3: Create `models/` package
Split Pydantic models into logical groups:

```python
# models/trip.py
class TripEvent(BaseModel): ...
class GpsPoint(BaseModel): ...
class Trip(BaseModel): ...
class TripUpdate(BaseModel): ...
class ManualTrip(BaseModel): ...
class FullTrip(BaseModel): ...

# models/car.py
class Car(BaseModel): ...
class CarCreate(BaseModel): ...
class CarUpdate(BaseModel): ...
class CarCredentials(BaseModel): ...
class CarTestRequest(BaseModel): ...

# models/location.py
class WebhookLocation(BaseModel): ...
class CustomLocation(BaseModel): ...

# models/export.py
class ExportRequest(BaseModel): ...
```

#### Step 1.4: Create `utils/` package
Extract pure utility functions:

```python
# utils/geo.py
def haversine(lat1, lon1, lat2, lon2) -> float: ...

# utils/routing.py
def get_osrm_distance_from_trail(gps_trail) -> float | None: ...
def get_google_maps_route_distance(from_lat, from_lon, to_lat, to_lon) -> float | None: ...
def calculate_route_deviation(driven_km, google_maps_km) -> dict: ...

# utils/ids.py
def generate_id() -> str: ...
```

### Phase 2: Authentication Layer

#### Step 2.1: Create `auth/` package

```python
# auth/google.py
def verify_google_token(token: str) -> dict: ...

# auth/middleware.py
class AuthMiddleware(BaseHTTPMiddleware): ...

# auth/dependencies.py
def get_current_user(...) -> str: ...
def get_user_from_header(...) -> str: ...
```

### Phase 3: Service Layer

#### Step 3.1: Create `services/location_service.py`
```python
class LocationService:
    def reverse_geocode(self, lat, lon, user_id=None) -> dict: ...
    def calculate_distance(self, lat1, lon1, lat2, lon2) -> dict: ...
    def is_skip_location(self, lat, lon) -> bool: ...
```

#### Step 3.2: Create `services/trip_service.py`
```python
class TripService:
    def get_trips(self, user_id, filters) -> list[Trip]: ...
    def create_trip(self, user_id, trip_data) -> Trip: ...
    def update_trip(self, trip_id, updates) -> Trip: ...
    def delete_trip(self, trip_id) -> None: ...
    def classify_trip(self, timestamp, start_loc, end_loc, distance) -> dict: ...
    def finalize_trip_from_audi(self, ...) -> dict: ...
    def finalize_trip_from_gps(self, ...) -> dict: ...
    def get_last_odometer(self, user_id) -> float: ...
```

#### Step 3.3: Create `services/car_service.py`
```python
class CarService:
    def get_cars(self, user_id) -> list[Car]: ...
    def create_car(self, user_id, car_data) -> Car: ...
    def update_car(self, car_id, updates) -> Car: ...
    def delete_car(self, car_id) -> None: ...
    def get_default_car_id(self, user_id) -> str | None: ...
    def get_car_id_by_device(self, user_id, device_id) -> str | None: ...
    def get_cars_with_credentials(self, user_id) -> list[dict]: ...
    def check_car_driving_status(self, car_info) -> dict | None: ...
    def find_driving_car(self, user_id) -> tuple[dict | None, str]: ...
    def save_last_parked_gps(self, user_id, car_id, lat, lng, timestamp): ...
```

#### Step 3.4: Create `services/webhook_service.py`
```python
class WebhookService:
    """State machine for trip tracking via webhooks"""
    def handle_ping(self, user_id, loc, car_id, device_id) -> dict: ...
    def handle_start(self, user_id, loc, car_id, device_id) -> dict: ...
    def handle_end(self, user_id, loc) -> dict: ...
    def handle_finalize(self, user_id) -> dict: ...
    def handle_cancel(self, user_id) -> dict: ...
    def get_status(self, user_id) -> dict: ...
    def check_stale_trips(self) -> dict: ...  # Safety net
```

#### Step 3.5: Create `services/export_service.py`
```python
class ExportService:
    def export_to_sheets(self, user_id, request) -> dict: ...
    def get_stats(self, user_id, filters) -> dict: ...
    def compare_odometer(self, user_id, car_id) -> dict: ...
```

### Phase 4: Routes Layer

#### Step 4.1: Create `routes/` package with APIRouter

```python
# routes/trips.py
from fastapi import APIRouter, Depends
from ..services.trip_service import TripService
from ..auth.dependencies import get_user_from_header

router = APIRouter(prefix="/trips", tags=["trips"])

@router.get("", response_model=list[Trip])
def get_trips(
    year: int | None = None,
    month: int | None = None,
    car_id: str | None = None,
    page: int = Query(default=1, ge=1),
    limit: int = Query(default=50, le=100),
    user_id: str = Depends(get_user_from_header),
    trip_service: TripService = Depends(),
):
    return trip_service.get_trips(user_id, year, month, car_id, page, limit)
```

#### Step 4.2: Create OAuth routers
```python
# routes/oauth/audi.py
router = APIRouter(prefix="/audi/auth", tags=["oauth", "audi"])

# routes/oauth/tesla.py
router = APIRouter(prefix="/cars/{car_id}/tesla", tags=["oauth", "tesla"])

# routes/oauth/vwgroup.py
router = APIRouter(prefix="/vwgroup/auth", tags=["oauth", "vwgroup"])

# routes/oauth/renault.py
router = APIRouter(prefix="/renault/auth", tags=["oauth", "renault"])
```

### Phase 5: Wire Everything Together

#### Step 5.1: Update `main.py` to ~50 lines

```python
# api/main.py
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .config import settings
from .auth.middleware import AuthMiddleware
from .routes import (
    auth, trips, cars, locations,
    webhooks, stats, charging
)
from .routes.oauth import audi, tesla, vwgroup, renault

app = FastAPI(title="mileage-tracker-api")

# Middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
app.add_middleware(AuthMiddleware)

# Include routers
app.include_router(auth.router)
app.include_router(trips.router)
app.include_router(cars.router)
app.include_router(locations.router)
app.include_router(webhooks.router)
app.include_router(stats.router)
app.include_router(charging.router)
app.include_router(audi.router)
app.include_router(tesla.router)
app.include_router(vwgroup.router)
app.include_router(renault.router)

@app.get("/")
def health():
    return {"status": "ok", "service": "mileage-tracker-api"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8080)
```

---

## Migration Strategy

### Approach: Parallel Structure with Gradual Migration

1. **Create new structure alongside old code**
   - Add new modules one at a time
   - Old `main.py` continues to work

2. **Import from new modules in main.py**
   - Replace inline definitions with imports
   - Test each replacement before moving on

3. **Move endpoints to routers incrementally**
   - Start with simplest endpoints (health, auth/status)
   - Progress to more complex (trips, webhooks)
   - Keep all endpoints functional throughout

4. **Delete old code only after verification**
   - Each section removed only after new version tested
   - Run full test suite after each migration step

### Testing Strategy

Each step must pass:
1. **Unit tests** for new service methods
2. **Integration tests** for API endpoints
3. **Manual smoke tests** for critical flows:
   - Trip start → ping → end flow
   - Car CRUD operations
   - OAuth flows (Audi, VW Group, Renault, Tesla)
   - Export to Google Sheets

---

## Detailed File Breakdown

### `config.py` (~100 lines)
- `Settings` class with all env vars
- `CONFIG` dict (locations, skip_location)
- Constants
- OAuth configs

### `database.py` (~100 lines)
- `get_db()` - Firestore client
- `get_trip_cache()` / `set_trip_cache()`
- `get_all_active_trips()`
- `load_custom_locations()`

### `models/` (~200 lines total)
- `trip.py` (~100 lines) - 6 models
- `car.py` (~80 lines) - 5 models
- `location.py` (~20 lines) - 2 models
- `export.py` (~10 lines) - 1 model

### `auth/` (~150 lines total)
- `google.py` (~30 lines)
- `middleware.py` (~60 lines)
- `dependencies.py` (~30 lines)

### `utils/` (~150 lines total)
- `geo.py` (~50 lines) - haversine, GPS calculations
- `routing.py` (~70 lines) - OSRM, Google Maps
- `ids.py` (~15 lines) - ID generation

### `services/` (~1500 lines total)
- `location_service.py` (~150 lines)
- `trip_service.py` (~400 lines)
- `car_service.py` (~350 lines)
- `webhook_service.py` (~400 lines)
- `export_service.py` (~200 lines)

### `routes/` (~1200 lines total)
- `auth.py` (~30 lines)
- `trips.py` (~200 lines)
- `cars.py` (~250 lines)
- `locations.py` (~80 lines)
- `webhooks.py` (~100 lines)
- `stats.py` (~150 lines)
- `charging.py` (~60 lines)
- `oauth/audi.py` (~150 lines)
- `oauth/tesla.py` (~80 lines)
- `oauth/vwgroup.py` (~150 lines)
- `oauth/renault.py` (~150 lines)

### New `main.py` (~50 lines)
- App initialization
- Middleware setup
- Router includes
- Health endpoint

---

## Benefits After Refactoring

| Before | After |
|--------|-------|
| 1 file, 4,185 lines | 30+ files, avg ~100 lines each |
| Hard to find code | Clear module structure |
| Can't test in isolation | Service layer fully testable |
| Mixed concerns | Clean separation |
| Difficult onboarding | Self-documenting structure |
| Merge conflicts common | Parallel development easier |

---

## Risk Mitigation

1. **No functionality changes** - Only restructuring code
2. **API contract unchanged** - Same endpoints, same request/response
3. **Gradual migration** - Can stop at any point
4. **Rollback easy** - Git makes reverting simple
5. **Test at each step** - Catch issues immediately

---

## Estimated Effort

| Phase | Description | Effort |
|-------|-------------|--------|
| 1 | Foundation (config, db, models, utils) | Small |
| 2 | Authentication layer | Small |
| 3 | Service layer | Medium |
| 4 | Routes layer | Medium |
| 5 | Wire together + cleanup | Small |

---

## Files to Delete After Refactoring

After successful migration, the following will be removed from `main.py`:
- All model definitions (moved to `models/`)
- All helper functions (moved to `utils/` and `services/`)
- All endpoint definitions (moved to `routes/`)
- All auth logic (moved to `auth/`)
- All config (moved to `config.py`)
- All database functions (moved to `database.py`)

The original `main.py` will be replaced with the 50-line version that just wires everything together.

---

## Next Steps

1. Review and approve this plan
2. Create the folder structure
3. Begin Phase 1 (Foundation)
4. Test after each step
5. Progress through phases
6. Final cleanup and documentation update
