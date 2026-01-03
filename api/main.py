"""
mileage-tracker API - Firestore + Export to Sheets
"""

import os
import math
import logging
from datetime import datetime, timezone

from typing import Optional
from collections.abc import Sequence

import requests
from fastapi import FastAPI, HTTPException, Query, Header, Depends
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, field_validator
from google.cloud import firestore
from google.oauth2 import id_token
from google.auth.transport import requests as google_requests

# OAuth Client IDs from environment
GOOGLE_CLIENT_IDS = [
    cid for cid in [
        os.environ.get("GOOGLE_OAUTH_CLIENT_ID", ""),
        os.environ.get("GOOGLE_WEB_CLIENT_ID", ""),
        os.environ.get("GOOGLE_IOS_CLIENT_ID", ""),
    ] if cid
]

# Auth settings
AUTH_ENABLED = os.environ.get("AUTH_ENABLED", "false").lower() == "true"
security = HTTPBearer(auto_error=False)

# No default user - all endpoints require authentication


def verify_google_token(token: str) -> dict:
    """Verify Google ID token and return user info"""
    try:
        # Try each client ID
        for client_id in GOOGLE_CLIENT_IDS:
            if not client_id:
                continue
            try:
                id_info = id_token.verify_oauth2_token(
                    token,
                    google_requests.Request(),
                    client_id
                )
                return {
                    "user_id": id_info.get("email"),
                    "sub": id_info.get("sub"),
                    "email": id_info.get("email"),
                    "name": id_info.get("name"),
                }
            except ValueError:
                continue
        raise ValueError("Invalid token for all client IDs")
    except Exception as e:
        raise ValueError(f"Token verification failed: {e}")


def get_current_user(
    credentials: HTTPAuthorizationCredentials | None = Depends(security),
    x_user_email: str | None = Header(None),
) -> str:
    """Get authenticated user from token"""
    # If auth is disabled, require email header
    if not AUTH_ENABLED:
        if not x_user_email:
            raise HTTPException(status_code=401, detail="X-User-Email header required")
        return x_user_email

    # Require Bearer token when auth is enabled
    if not credentials:
        raise HTTPException(status_code=401, detail="Authentication required")

    # Verify the token
    try:
        user_info = verify_google_token(credentials.credentials)
        return user_info["email"]
    except ValueError as e:
        raise HTTPException(status_code=401, detail=str(e))


def get_user_from_header(x_user_email: str | None = Header(None)) -> str:
    """Get user ID from header - requires header to be present"""
    if not x_user_email:
        raise HTTPException(status_code=401, detail="X-User-Email header required")
    return x_user_email

from google.auth import default
from googleapiclient.discovery import build

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI(title="mileage-tracker-api")

# CORS for frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Auth middleware - validates token and injects user email into request state
from starlette.middleware.base import BaseHTTPMiddleware
from starlette.requests import Request
from starlette.responses import JSONResponse


class AuthMiddleware(BaseHTTPMiddleware):
    # Paths that don't require auth
    PUBLIC_PATHS = {"/", "/auth/status", "/docs", "/openapi.json", "/redoc", "/audi/check-trip", "/audi/odometer-now", "/trips/full"}
    # Path prefixes that don't require auth
    PUBLIC_PREFIXES = ("/webhook/",)

    async def dispatch(self, request: Request, call_next):
        # Skip auth for OPTIONS requests (CORS preflight)
        if request.method == "OPTIONS":
            return await call_next(request)

        # Skip auth for public paths
        if request.url.path in self.PUBLIC_PATHS:
            return await call_next(request)

        # Skip auth for public prefixes (webhooks, etc.)
        if any(request.url.path.startswith(prefix) for prefix in self.PUBLIC_PREFIXES):
            return await call_next(request)

        # Skip if auth is disabled
        if not AUTH_ENABLED:
            return await call_next(request)

        # Try to get token from Authorization header
        auth_header = request.headers.get("Authorization")
        x_user_email = request.headers.get("X-User-Email")

        if auth_header and auth_header.startswith("Bearer "):
            token = auth_header[7:]
            try:
                user_info = verify_google_token(token)
                # Inject user email into request state
                request.state.user_email = user_info["email"]
                return await call_next(request)
            except ValueError as e:
                return JSONResponse(
                    status_code=401,
                    content={"detail": f"Invalid token: {e}"}
                )

        # No auth provided - require Bearer token
        return JSONResponse(
            status_code=401,
            content={"detail": "Authentication required. Provide Bearer token."}
        )


app.add_middleware(AuthMiddleware)


@app.get("/auth/me")
def get_me(user: str = Depends(get_current_user)):
    """Get current authenticated user"""
    return {"user": user, "auth_enabled": AUTH_ENABLED}


@app.get("/auth/status")
def get_auth_status():
    """Check if auth is enabled"""
    return {"auth_enabled": AUTH_ENABLED}


# Config from environment
CONFIG = {
    "project_id": os.environ.get("PROJECT_ID"),
    "maps_api_key": os.environ.get("MAPS_API_KEY"),
    "locations": {
        "Thuis": {
            "lat": float(os.environ.get("CONFIG_HOME_LAT", 0)),
            "lon": float(os.environ.get("CONFIG_HOME_LON", 0)),
            "radius": 150,
            "is_business": False,
        },
        "Kantoor": {
            "lat": float(os.environ.get("CONFIG_OFFICE_LAT", 0)),
            "lon": float(os.environ.get("CONFIG_OFFICE_LON", 0)),
            "radius": 150,
            "is_business": True,
        },
    },
    "skip_location": {
        "lat": float(os.environ.get("CONFIG_SKIP_LAT", 0)),
        "lon": float(os.environ.get("CONFIG_SKIP_LON", 0)),
        "radius": 200,  # Slightly larger radius for intermediate stops
    },
    "start_odometer": float(os.environ.get("CONFIG_START_ODOMETER", 0)),
    "private_days": [5, 6],  # Saturday, Sunday
    "min_trip_km": 0.1,
}

# Firestore client (lazy init)
_db: firestore.Client | None = None
_locations_loaded = False

# Legacy trip cache for old webhook endpoint
trip_cache = {}


def get_db() -> firestore.Client:
    global _db
    if _db is None:
        _db = firestore.Client(project=CONFIG["project_id"])
    return _db


def load_custom_locations(user_id: str | None = None):
    """Load custom locations from Firestore into CONFIG (global, not per-user)"""
    global _locations_loaded
    if _locations_loaded:
        return
    try:
        db = get_db()
        docs = db.collection("locations").stream()
        for doc in docs:
            data = doc.to_dict()
            CONFIG["locations"][doc.id] = {
                "lat": data.get("lat", 0),
                "lon": data.get("lng", 0),
                "radius": 150,
                "is_business": True,
            }
        _locations_loaded = True
        logger.info(f"Loaded {len(CONFIG['locations'])} locations")
    except Exception as e:
        logger.error(f"Failed to load custom locations: {e}")


# Trip cache in Firestore to survive cold starts
def get_trip_cache(user_id: str) -> dict | None:
    """Get cached trip start from Firestore (per-user)"""
    try:
        db = get_db()
        doc = db.collection("users").document(user_id).collection("cache").document("trip_start").get()
        if doc.exists:
            return doc.to_dict()
    except Exception as e:
        logger.error(f"Failed to get trip cache: {e}")
    return None


def set_trip_cache(data: dict | None, user_id: str):
    """Set or clear trip start cache in Firestore (per-user)"""
    try:
        db = get_db()
        ref = db.collection("users").document(user_id).collection("cache").document("trip_start")
        if data:
            ref.set(data)
        else:
            ref.delete()
    except Exception as e:
        logger.error(f"Failed to set trip cache: {e}")


def get_all_active_trips() -> list[tuple[str, dict]]:
    """Get all active trip caches across all users (for scheduler)"""
    active_trips = []
    try:
        db = get_db()
        # Query all users' trip caches
        users_ref = db.collection("users").stream()
        for user_doc in users_ref:
            user_id = user_doc.id
            cache_doc = db.collection("users").document(user_id).collection("cache").document("trip_start").get()
            if cache_doc.exists:
                cache = cache_doc.to_dict()
                if cache and cache.get("active"):
                    active_trips.append((user_id, cache))
    except Exception as e:
        logger.error(f"Failed to get active trips: {e}")
    return active_trips




# === Models ===


class TripEvent(BaseModel):
    event: str
    lat: float
    lon: float
    timestamp: str


class GpsPoint(BaseModel):
    lat: float
    lng: float
    timestamp: str | None = None


class Trip(BaseModel):
    id: str
    date: str
    start_time: str
    end_time: str
    from_address: str
    to_address: str
    from_lat: float | None = None
    from_lon: float | None = None
    to_lat: float | None = None
    to_lon: float | None = None
    distance_km: float
    trip_type: str
    business_km: float
    private_km: float
    start_odo: float
    end_odo: float
    notes: str = ""
    created_at: str | None = None
    car_id: str | None = None  # "audi", "prive", or "unknown" (show red in UI)
    gps_trail: list[GpsPoint] = []  # Route waypoints for Google Maps
    google_maps_km: float | None = None  # Shortest route distance from Google Maps
    route_deviation_percent: float | None = None  # How much longer than Google Maps route (%)
    route_flag: str | None = None  # "long_route" if significantly longer than Google Maps


class TripUpdate(BaseModel):
    date: str | None = None
    start_time: str | None = None
    end_time: str | None = None
    from_address: str | None = None
    to_address: str | None = None
    distance_km: float | None = None
    trip_type: str | None = None
    business_km: float | None = None
    private_km: float | None = None
    notes: str | None = None
    route_flag: str | None = None  # Can be set to "long_route" or null
    car_id: str | None = None


class ExportRequest(BaseModel):
    spreadsheet_id: str
    year: int | None = None
    month: int | None = None
    car_id: str | None = None  # Filter by specific car
    separate_sheets: bool = False  # Create separate sheets per car


class WebhookLocation(BaseModel):
    lat: float
    lng: float

    @field_validator('lat')
    @classmethod
    def validate_lat(cls, v):
        if not -90 <= v <= 90:
            raise ValueError(f'Latitude must be between -90 and 90, got {v}')
        return v

    @field_validator('lng')
    @classmethod
    def validate_lng(cls, v):
        if not -180 <= v <= 180:
            raise ValueError(f'Longitude must be between -180 and 180, got {v}')
        return v


class Car(BaseModel):
    """Car model for multi-car support"""
    id: str
    name: str
    brand: str = "other"  # audi, vw, skoda, seat, cupra, renault, tesla, bmw, mercedes, other
    color: str = "#3B82F6"  # Hex color for UI
    icon: str = "car"  # car, car-suv, car-sports, car-van, car-hatchback
    is_default: bool = False
    carplay_device_id: str | None = None  # For auto-detection
    start_odometer: float = 0  # Starting odometer for km verification per car
    created_at: str | None = None
    last_used: str | None = None
    # Stats (computed)
    total_trips: int = 0
    total_km: float = 0


class CarCreate(BaseModel):
    """Create a new car"""
    name: str
    brand: str = "other"
    color: str = "#3B82F6"
    icon: str = "car"
    start_odometer: float = 0


class CarUpdate(BaseModel):
    """Update car details"""
    name: str | None = None
    brand: str | None = None
    color: str | None = None
    icon: str | None = None
    is_default: bool | None = None
    carplay_device_id: str | None = None
    start_odometer: float | None = None


class CarCredentials(BaseModel):
    """Car API credentials"""
    brand: str = "audi"
    username: str = ""
    password: str = ""
    country: str = "NL"
    locale: str = "nl_NL"
    spin: str = ""
    start_odometer: float = 0


# === Per-Car Credentials Management ===


def get_cars_with_credentials(user_id: str) -> list[dict]:
    """Get all cars that have API credentials configured in their own subcollection"""
    db = get_db()
    cars_ref = db.collection("users").document(user_id).collection("cars")
    cars_with_creds = []

    for car_doc in cars_ref.stream():
        car_id = car_doc.id
        car_data = car_doc.to_dict()

        # Only use car's own credentials - no fallbacks
        creds_doc = cars_ref.document(car_id).collection("credentials").document("api").get()
        if creds_doc.exists:
            creds = creds_doc.to_dict()
            if creds.get("username") and creds.get("password"):
                cars_with_creds.append({
                    "car_id": car_id,
                    "name": car_data.get("name", car_id),
                    "brand": creds.get("brand", car_data.get("brand", "")).lower(),
                    "credentials": creds,
                })

    return cars_with_creds


def check_car_driving_status(car_info: dict) -> dict | None:
    """Check if a specific car is driving. Returns car data if driving, None if parked/error."""
    from car_providers import VWGroupProvider, RenaultProvider, VW_GROUP_BRANDS

    creds = car_info["credentials"]
    brand = car_info["brand"]

    try:
        if brand == "renault":
            provider = RenaultProvider(
                username=creds["username"],
                password=creds["password"],
                locale=creds.get("locale", "nl_NL"),
                vin=creds.get("vin"),
            )
        elif brand in VW_GROUP_BRANDS:
            provider = VWGroupProvider(
                brand=brand,
                username=creds["username"],
                password=creds["password"],
                country=creds.get("country", "NL"),
                spin=creds.get("spin"),
            )
        else:
            logger.warning(f"Unknown brand {brand} for car {car_info['car_id']}")
            return None

        data = provider.get_data()
        provider.disconnect()

        raw = data.raw_data or {}

        # Get vehicle state
        vehicle_state = raw.get("state", {}).get("val", "unknown")
        is_parked = "parked" in str(vehicle_state).lower()

        # Get odometer
        odometer = data.odometer_km

        # Get GPS position
        position = raw.get("position", {})
        lat = position.get("latitude", {}).get("val")
        lng = position.get("longitude", {}).get("val")

        return {
            "car_id": car_info["car_id"],
            "name": car_info["name"],
            "is_parked": is_parked,
            "is_driving": not is_parked,
            "state": str(vehicle_state),
            "odometer": odometer,
            "lat": lat,
            "lng": lng,
        }

    except Exception as e:
        logger.error(f"Error checking car {car_info['car_id']}: {e}")
        return None


def find_driving_car(user_id: str) -> dict | None:
    """Find which car (if any) is currently driving"""
    cars = get_cars_with_credentials(user_id)
    logger.info(f"Checking {len(cars)} cars for driving status")

    for car_info in cars:
        status = check_car_driving_status(car_info)
        if status and status["is_driving"]:
            logger.info(f"Found driving car: {status['name']} ({status['car_id']})")
            return status

    logger.info("No cars are driving")
    return None


# === Endpoints ===


@app.get("/")
def health():
    return {"status": "ok", "service": "mileage-tracker-api"}


@app.post("/webhook/ping")
def webhook_ping(loc: WebhookLocation, user: str | None = None, car_id: str | None = None, device_id: str | None = None):
    """iPhone Shortcuts - GPS ping. Collects coordinates during trip and checks car status."""
    user_id = user
    if not user_id:
        raise HTTPException(status_code=401, detail="User parameter required")
    timestamp = datetime.utcnow().isoformat() + "Z"
    logger.info(f"GPS ping at {loc.lat}, {loc.lng} for user {user_id}, car_id={car_id}, device_id={device_id}")

    cache = get_trip_cache(user_id)

    # If no active trip, start one
    if not cache or not cache.get("active"):
        # Determine car_id: explicit car_id > device_id lookup > default car
        effective_car_id = car_id or get_car_id_by_device(user_id, device_id) or get_default_car_id(user_id)
        logger.info(f"No active trip for {user_id} - starting new trip for car {effective_car_id}")
        cache = {
            "active": True,
            "user_id": user_id,
            "car_id": effective_car_id,
            "start_time": timestamp,
            "start_odo": None,
            "last_odo": None,
            "no_driving_count": 0,
            "parked_count": 0,
            "gps_events": [],
        }

    # Add GPS event (including skip locations - we filter at finalize time)
    gps_events = cache.get("gps_events", [])
    gps_events.append({
        "lat": loc.lat,
        "lng": loc.lng,
        "timestamp": timestamp,
        "is_skip": is_skip_location(loc.lat, loc.lng),
    })
    cache["gps_events"] = gps_events
    logger.info(f"GPS event added, total: {len(gps_events)}, is_skip: {gps_events[-1]['is_skip']}")

    # Check car status on each ping
    start_odo = cache.get("start_odo")

    if start_odo is None:
        # First phase: find which car is driving
        driving_car = find_driving_car(user_id)

        if not driving_car:
            no_driving_count = cache.get("no_driving_count", 0) + 1
            cache["no_driving_count"] = no_driving_count
            logger.info(f"No cars driving, count: {no_driving_count}/3")

            if no_driving_count >= 3:
                # Cancel after 3 pings with no car driving
                logger.info("No tracked car driving after 3 pings - cancelling trip")
                set_trip_cache(None, user_id)
                return {"status": "cancelled", "reason": "no_tracked_car_driving", "user": user_id}

            set_trip_cache(cache, user_id)
            return {"status": "waiting_for_car", "no_driving_count": no_driving_count, "user": user_id}

        # Found a driving car - assign it to this trip
        cache["car_id"] = driving_car["car_id"]
        cache["car_name"] = driving_car["name"]
        cache["start_odo"] = driving_car["odometer"]
        cache["last_odo"] = driving_car["odometer"]
        cache["no_driving_count"] = 0
        cache["parked_count"] = 0

        if driving_car.get("lat") and driving_car.get("lng"):
            cache["gps_trail"] = [{"lat": driving_car["lat"], "lng": driving_car["lng"], "timestamp": timestamp}]
            cache["audi_gps"] = {"lat": driving_car["lat"], "lng": driving_car["lng"], "timestamp": timestamp}

        set_trip_cache(cache, user_id)
        logger.info(f"Trip assigned to {driving_car['name']}, start_odo={driving_car['odometer']}")
        return {"status": "trip_started", "car": driving_car["name"], "start_odo": driving_car["odometer"], "user": user_id}

    # Subsequent pings: check assigned car status
    assigned_car_id = cache.get("car_id")
    if not assigned_car_id:
        logger.warning("No car_id in cache - cancelling")
        set_trip_cache(None, user_id)
        return {"status": "cancelled", "reason": "no_car_assigned", "user": user_id}

    cars = get_cars_with_credentials(user_id)
    car_info = next((c for c in cars if c["car_id"] == assigned_car_id), None)

    if not car_info:
        logger.warning(f"Car {assigned_car_id} not found - cancelling")
        set_trip_cache(None, user_id)
        return {"status": "cancelled", "reason": "car_not_found", "user": user_id}

    car_status = check_car_driving_status(car_info)
    if not car_status:
        logger.warning(f"Could not check car {assigned_car_id} status")
        set_trip_cache(cache, user_id)
        return {"status": "ping_recorded", "error": "car_status_unavailable", "user": user_id}

    current_odo = car_status["odometer"]
    is_parked = car_status["is_parked"]
    vehicle_state = car_status["state"]
    car_lat = car_status.get("lat")
    car_lng = car_status.get("lng")
    last_odo = cache.get("last_odo")

    # Store GPS from car
    if car_lat and car_lng:
        gps_trail = cache.get("gps_trail", [])
        if not gps_trail or (gps_trail[-1]["lat"] != car_lat or gps_trail[-1]["lng"] != car_lng):
            gps_trail.append({"lat": car_lat, "lng": car_lng, "timestamp": timestamp})
            cache["gps_trail"] = gps_trail
        cache["audi_gps"] = {"lat": car_lat, "lng": car_lng, "timestamp": timestamp}

    # Validate odometer (ignore if API returned stale/bad data)
    if current_odo < last_odo:
        logger.warning(f"Odometer went backwards: {current_odo} < {last_odo} - ignoring bad data")
        current_odo = last_odo  # Use last known good value

    # Track parked count
    if is_parked or current_odo == last_odo:
        cache["parked_count"] = cache.get("parked_count", 0) + 1
    else:
        cache["parked_count"] = 0
        cache["skip_pause_count"] = 0  # Reset skip location counter when moving
        cache["last_odo"] = current_odo
        # Clear end_triggered only if car is actually moving (odometer increased)
        if cache.get("end_triggered"):
            logger.info(f"Clearing end_triggered - car is moving, continuing trip")
            cache["end_triggered"] = None

    parked_count = cache.get("parked_count", 0)
    logger.info(f"Car {cache.get('car_name')}: state={vehicle_state}, parked_count={parked_count}, odo={current_odo}")

    # Check if parked 3x in a row - trip is done
    if parked_count >= 3:
        total_km = current_odo - start_odo
        car_gps = cache.get("audi_gps")

        if total_km <= 0:
            logger.info(f"Trip had {total_km} km - skipping")
            set_trip_cache(None, user_id)
            return {"status": "skipped", "reason": "zero_or_negative_km", "user": user_id}

        # Check if parked at skip location (but don't wait forever - max 6 pings ~30min)
        if car_gps and is_skip_location(car_gps["lat"], car_gps["lng"]):
            skip_pause_count = cache.get("skip_pause_count", 0) + 1
            cache["skip_pause_count"] = skip_pause_count
            if skip_pause_count < 6:
                logger.info(f"Parked at skip location - pausing ({skip_pause_count}/6). Total km: {total_km}")
                set_trip_cache(cache, user_id)
                return {"status": "paused_at_skip", "total_km": total_km, "pause_count": skip_pause_count, "user": user_id}
            else:
                logger.info(f"Skip location timeout after {skip_pause_count} pings - finalizing anyway")

        # Finalize trip
        logger.info(f"Trip complete! {total_km} km driven")
        start_gps = gps_events[0] if gps_events else None
        if not start_gps:
            logger.warning("No start GPS from iPhone")
            set_trip_cache(None, user_id)
            return {"status": "skipped", "reason": "no_start_gps", "user": user_id}

        if not car_gps:
            logger.warning("No end GPS from car")
            set_trip_cache(None, user_id)
            return {"status": "skipped", "reason": "no_end_gps", "user": user_id}

        trip_result = finalize_trip_from_audi(
            start_gps=start_gps,
            end_gps=car_gps,
            start_odo=start_odo,
            end_odo=current_odo,
            start_time=cache.get("start_time"),
            gps_trail=cache.get("gps_trail", []),
            user_id=user_id,
            car_id=assigned_car_id,
        )

        set_trip_cache(None, user_id)
        return {"status": "finalized", "trip": trip_result, "user": user_id}

    set_trip_cache(cache, user_id)
    return {"status": "moving" if current_odo != last_odo else "waiting", "current_odo": current_odo, "parked_count": parked_count, "user": user_id}


@app.post("/webhook/start")
def webhook_start(loc: WebhookLocation, user: str | None = None, car_id: str | None = None, device_id: str | None = None):
    """iPhone Shortcuts - Bluetooth/CarPlay connected. Just records GPS."""
    # Delegate to ping - start is just another GPS event, pass car_id and device_id through
    return webhook_ping(loc, user, car_id, device_id)


@app.post("/webhook/end")
def webhook_end(loc: WebhookLocation, user: str | None = None):
    """iPhone Shortcuts - Bluetooth/CarPlay disconnected. Tries to finalize trip immediately."""
    user_id = user
    if not user_id:
        raise HTTPException(status_code=401, detail="User parameter required")

    timestamp = datetime.utcnow().isoformat() + "Z"
    logger.info(f"End event at {loc.lat}, {loc.lng} for user {user_id}")

    cache = get_trip_cache(user_id)
    if not cache or not cache.get("active"):
        return {"status": "ignored", "reason": "no_active_trip"}

    # Add final GPS event
    gps_events = cache.get("gps_events", [])
    gps_events.append({
        "lat": loc.lat,
        "lng": loc.lng,
        "timestamp": timestamp,
        "is_skip": is_skip_location(loc.lat, loc.lng),
    })
    cache["gps_events"] = gps_events

    # Mark that end was triggered - helps safety net know this trip should close
    cache["end_triggered"] = timestamp

    start_odo = cache.get("start_odo")
    assigned_car_id = cache.get("car_id")

    # If we never got odometer data, try one more time
    if start_odo is None:
        driving_car = find_driving_car(user_id)
        if driving_car:
            cache["car_id"] = driving_car["car_id"]
            cache["car_name"] = driving_car["name"]
            cache["start_odo"] = driving_car["odometer"]
            cache["last_odo"] = driving_car["odometer"]
            start_odo = driving_car["odometer"]
            assigned_car_id = driving_car["car_id"]
            if driving_car.get("lat") and driving_car.get("lng"):
                cache["audi_gps"] = {"lat": driving_car["lat"], "lng": driving_car["lng"], "timestamp": timestamp}
            logger.info(f"End event captured car: {driving_car['name']}, odo={start_odo}")

    # Try to get final odometer and finalize
    if assigned_car_id and start_odo is not None:
        cars = get_cars_with_credentials(user_id)
        car_info = next((c for c in cars if c["car_id"] == assigned_car_id), None)

        if car_info:
            car_status = check_car_driving_status(car_info)
            if car_status:
                current_odo = car_status["odometer"]
                car_lat = car_status.get("lat")
                car_lng = car_status.get("lng")

                if car_lat and car_lng:
                    cache["audi_gps"] = {"lat": car_lat, "lng": car_lng, "timestamp": timestamp}

                total_km = current_odo - start_odo
                car_gps = cache.get("audi_gps")

                # Only finalize if car is actually parked (avoid mid-trip cable disconnect)
                if car_status["is_parked"]:
                    if total_km == 0:
                        logger.info("End event: 0 km driven - skipping")
                        set_trip_cache(None, user_id)
                        return {"status": "skipped", "reason": "zero_km", "user": user_id}

                    if car_gps and is_skip_location(car_gps["lat"], car_gps["lng"]):
                        logger.info(f"End event: at skip location - keeping active")
                        cache["end_triggered"] = None  # Clear so safety net doesn't finalize
                        set_trip_cache(cache, user_id)
                        return {"status": "paused_at_skip", "total_km": total_km, "user": user_id}

                    start_gps = gps_events[0] if gps_events else None
                    if start_gps and car_gps:
                        logger.info(f"End event: finalizing trip, {total_km} km")
                        trip_result = finalize_trip_from_audi(
                            start_gps=start_gps,
                            end_gps=car_gps,
                            start_odo=start_odo,
                            end_odo=current_odo,
                            start_time=cache.get("start_time"),
                            gps_trail=cache.get("gps_trail", []),
                            user_id=user_id,
                            car_id=assigned_car_id,
                        )
                        set_trip_cache(None, user_id)
                        return {"status": "finalized", "trip": trip_result, "user": user_id}

    # Couldn't finalize yet - save cache and let safety net handle it
    set_trip_cache(cache, user_id)
    logger.info(f"End event: couldn't finalize, saved for safety net")
    return {"status": "pending", "reason": "waiting_for_safety_net", "user": user_id}


@app.post("/webhook/finalize")
def webhook_finalize(user: str | None = None):
    """Force finalize a pending trip by fetching current odometer"""
    user_id = user
    if not user_id:
        raise HTTPException(status_code=401, detail="User parameter required")
    cache = get_trip_cache(user_id)
    if not cache or not cache.get("active"):
        return {"status": "ignored", "reason": "no_active_trip"}

    # Mark as end triggered so safety net will pick it up
    cache["end_triggered"] = datetime.utcnow().isoformat() + "Z"
    set_trip_cache(cache, user_id)

    # Try to finalize immediately using same logic as safety net
    return check_stale_trips()


@app.post("/webhook/cancel")
def webhook_cancel(user: str | None = None, x_user_email: str | None = Header(None)):
    """Cancel the current trip without saving"""
    user_id = user or x_user_email
    if not user_id:
        raise HTTPException(status_code=401, detail="User required")
    cache = get_trip_cache(user_id)
    if not cache or not cache.get("active"):
        return {"status": "ignored", "reason": "no_active_trip"}

    set_trip_cache(None, user_id)
    logger.info(f"Trip cancelled by user {user_id}")
    return {"status": "cancelled"}


@app.get("/webhook/status")
def webhook_status(user: str | None = None, x_user_email: str | None = Header(None)):
    """Check current trip status"""
    user_id = user or x_user_email
    if not user_id:
        raise HTTPException(status_code=401, detail="User required")
    cache = get_trip_cache(user_id)
    if not cache or not cache.get("active"):
        return {"active": False}

    gps_events = cache.get("gps_events", [])
    return {
        "active": True,
        "start_time": cache.get("start_time"),
        "start_odo": cache.get("start_odo"),
        "last_odo": cache.get("last_odo"),
        "last_odo_change": cache.get("last_odo_change"),
        "gps_count": len(gps_events),
        "first_gps": gps_events[0] if gps_events else None,
        "last_gps": gps_events[-1] if gps_events else None,
    }


def is_skip_location(lat: float, lon: float) -> bool:
    """Check if location is a skip location (e.g., daycare)"""
    skip = CONFIG["skip_location"]
    if skip["lat"] == 0:
        return False
    distance = haversine(lat, lon, skip["lat"], skip["lon"])
    return distance <= skip["radius"]


def finalize_trip(cache: dict) -> dict:
    """Finalize a pending trip from cache and save to Firestore"""
    start = cache["start"]
    end = cache["end"]
    car_id = cache.get("car_id")

    logger.info(f"Finalizing trip: car_id={car_id}")

    # Create TripEvent-like object for end
    end_event = TripEvent(
        event="trip_end",
        lat=end["lat"],
        lon=end["lon"],
        timestamp=end["timestamp"],
    )

    # Process trip (geocode, calculate distance, etc.)
    start_loc = reverse_geocode(start["lat"], start["lon"])
    end_loc = reverse_geocode(end_event.lat, end_event.lon)
    distance = calculate_distance(start["lat"], start["lon"], end_event.lat, end_event.lon)

    if distance["distance_km"] < CONFIG["min_trip_km"]:
        set_trip_cache(None)
        return {"ignored": True, "reason": "too_short"}

    classification = classify_trip(start["timestamp"], start_loc, end_loc, distance["distance_km"])
    prev_odo = get_last_odometer()

    trip_id = generate_id()
    start_dt = datetime.fromisoformat(start["timestamp"].replace("Z", "+00:00"))
    end_dt = datetime.fromisoformat(end_event.timestamp.replace("Z", "+00:00"))

    trip_data = {
        "id": trip_id,
        "date": start_dt.strftime("%d-%m-%Y"),
        "start_time": start_dt.strftime("%H:%M"),
        "end_time": end_dt.strftime("%H:%M"),
        "from_address": start_loc["label"] or start_loc["address"],
        "to_address": end_loc["label"] or end_loc["address"],
        "from_lat": start_loc.get("lat"),
        "from_lon": start_loc.get("lon"),
        "to_lat": end_loc.get("lat"),
        "to_lon": end_loc.get("lon"),
        "distance_km": round(distance["distance_km"], 1),
        "trip_type": classification["type"],
        "business_km": round(classification["business_km"], 1),
        "private_km": round(classification["private_km"], 1),
        "start_odo": round(prev_odo, 1),
        "end_odo": round(prev_odo + distance["distance_km"], 1),
        "notes": "",
        "created_at": datetime.utcnow().isoformat(),
        "car_id": car_id or "unknown",  # Track which car, unknown = show red
    }

    db = get_db()
    db.collection("trips").document(trip_id).set(trip_data)
    logger.info(f"Trip finalized: {trip_id}, car_id={car_id}")

    # Clear cache
    set_trip_cache(None)

    return trip_data


@app.post("/webhook")
def handle_webhook(event: TripEvent):
    """iPhone Shortcuts webhook for simple trip start/end events"""
    logger.info(f"Webhook: {event.event} at {event.lat}, {event.lon}")

    if event.event == "trip_start":
        trip_cache["start"] = {
            "lat": event.lat,
            "lon": event.lon,
            "timestamp": event.timestamp,
        }
        return {"status": "start_cached"}

    if event.event == "trip_end":
        start = trip_cache.pop("start", None)
        if not start:
            start = {"lat": event.lat, "lon": event.lon, "timestamp": event.timestamp}

        trip = process_trip(start, event)
        return {"status": "trip_logged", "trip_id": trip.get("id")}

    raise HTTPException(status_code=400, detail="Invalid event")


@app.get("/trips", response_model=Sequence[Trip])
def get_trips(
    year: int | None = None,
    month: int | None = None,
    car_id: str | None = None,
    page: int = Query(default=1, ge=1),
    limit: int = Query(default=50, le=100),
    x_user_email: str | None = Header(None),
):
    """Get trips with optional filtering, sorted by date/time descending"""
    user_id = get_user_from_header(x_user_email)
    db = get_db()
    # Sort by document ID descending - IDs are YYYYMMDD-HHMM-XXX format
    # This gives correct chronological order
    query = db.collection("trips").where(
        filter=firestore.FieldFilter("user_id", "==", user_id)
    ).order_by(
        "__name__", direction=firestore.Query.DESCENDING
    )

    if year and month:
        start = f"{month:02d}-{year}"
        end = f"{month:02d}-{year}"
        query = query.where(filter=firestore.FieldFilter("date", ">=", f"01-{start}"))
        query = query.where(filter=firestore.FieldFilter("date", "<=", f"31-{end}"))

    # Pagination: skip (page-1)*limit items
    offset = (page - 1) * limit

    # If car_id filter is specified, filter trips by exact match
    if car_id:
        docs = list(query.limit((offset + limit) * 3).stream())
        filtered_docs = [doc for doc in docs if doc.to_dict().get("car_id") == car_id]
        return [doc_to_trip(doc) for doc in filtered_docs[offset:offset + limit]]
    else:
        docs = list(query.limit(offset + limit).stream())
        return [doc_to_trip(doc) for doc in docs[offset:]]


class ManualTrip(BaseModel):
    date: str
    start_time: str = "09:00"
    end_time: str = "10:00"
    from_address: str
    to_address: str
    distance_km: float
    trip_type: str = "B"
    car_id: str | None = None


class FullTrip(BaseModel):
    """Trip with all details including GPS trail"""
    date: str
    start_time: str
    end_time: str
    from_lat: float
    from_lon: float
    to_lat: float
    to_lon: float
    distance_km: float
    trip_type: str = "P"
    start_odo: float
    end_odo: float
    car_id: str | None = None
    gps_trail: list[GpsPoint] = []


class CustomLocation(BaseModel):
    name: str
    lat: float
    lng: float


@app.post("/trips", response_model=Trip)
def create_trip(trip: ManualTrip, x_user_email: str | None = Header(None)):
    """Create a manual trip"""
    user_id = get_user_from_header(x_user_email)
    db = get_db()
    trip_id = generate_id()
    prev_odo = get_last_odometer(user_id)

    # Calculate business/private km based on type
    if trip.trip_type == "B":
        business_km = trip.distance_km
        private_km = 0
    elif trip.trip_type == "P":
        business_km = 0
        private_km = trip.distance_km
    else:  # Mixed
        business_km = trip.distance_km / 2
        private_km = trip.distance_km / 2

    # Lookup lat/lon from known locations
    load_custom_locations(user_id)
    from_lat, from_lon, to_lat, to_lon = None, None, None, None
    for label, loc in CONFIG["locations"].items():
        if label == trip.from_address and loc["lat"] != 0:
            from_lat, from_lon = loc["lat"], loc["lon"]
        if label == trip.to_address and loc["lat"] != 0:
            to_lat, to_lon = loc["lat"], loc["lon"]

    # Use provided car_id, fall back to default car
    effective_car_id = trip.car_id or get_default_car_id(user_id)

    trip_data = {
        "id": trip_id,
        "date": trip.date,
        "start_time": trip.start_time,
        "end_time": trip.end_time,
        "from_address": trip.from_address,
        "to_address": trip.to_address,
        "from_lat": from_lat,
        "from_lon": from_lon,
        "to_lat": to_lat,
        "to_lon": to_lon,
        "distance_km": trip.distance_km,
        "trip_type": trip.trip_type,
        "business_km": round(business_km, 1),
        "private_km": round(private_km, 1),
        "start_odo": round(prev_odo, 1),
        "end_odo": round(prev_odo + trip.distance_km, 1),
        "notes": "",
        "created_at": datetime.utcnow().isoformat(),
        "car_id": effective_car_id,
        "user_id": user_id,
    }

    db.collection("trips").document(trip_id).set(trip_data)
    return doc_to_trip(db.collection("trips").document(trip_id).get())


@app.post("/trips/full")
def create_full_trip(trip: FullTrip, user: str | None = None):
    """Create a trip with full details including GPS trail (public endpoint for recovery)"""
    if not user:
        raise HTTPException(status_code=401, detail="User parameter required")
    db = get_db()
    trip_id = generate_id()

    # Geocode start and end
    start_loc = reverse_geocode(trip.from_lat, trip.from_lon)
    end_loc = reverse_geocode(trip.to_lat, trip.to_lon)

    # Get Google Maps distance
    google_maps_km = get_google_maps_route_distance(trip.from_lat, trip.from_lon, trip.to_lat, trip.to_lon)
    route_info = calculate_route_deviation(trip.distance_km, google_maps_km)

    trip_data = {
        "id": trip_id,
        "date": trip.date,
        "start_time": trip.start_time,
        "end_time": trip.end_time,
        "from_address": start_loc["label"] or start_loc["address"],
        "to_address": end_loc["label"] or end_loc["address"],
        "from_lat": trip.from_lat,
        "from_lon": trip.from_lon,
        "to_lat": trip.to_lat,
        "to_lon": trip.to_lon,
        "distance_km": round(trip.distance_km, 1),
        "trip_type": trip.trip_type,
        "business_km": 0 if trip.trip_type == "P" else round(trip.distance_km, 1),
        "private_km": round(trip.distance_km, 1) if trip.trip_type == "P" else 0,
        "start_odo": round(trip.start_odo, 1),
        "end_odo": round(trip.end_odo, 1),
        "notes": "",
        "created_at": datetime.utcnow().isoformat(),
        "car_id": trip.car_id or get_default_car_id(user),
        "user_id": user,
        "gps_trail": [{"lat": p.lat, "lng": p.lng, "timestamp": p.timestamp} for p in trip.gps_trail],
        "google_maps_km": google_maps_km,
        "route_deviation_percent": route_info.get("deviation_percent"),
        "route_flag": route_info.get("flag"),
    }

    db.collection("trips").document(trip_id).set(trip_data)
    return doc_to_trip(db.collection("trips").document(trip_id).get())


@app.post("/trips/backfill-latlon")
def backfill_latlon():
    """Backfill lat/lon for existing trips based on known location names"""
    db = get_db()
    load_custom_locations()

    updated = 0
    trips = db.collection("trips").stream()

    for doc in trips:
        d = doc.to_dict()
        updates = {}

        # Check from_address
        if not d.get("from_lat"):
            for label, loc in CONFIG["locations"].items():
                if label == d.get("from_address") and loc["lat"] != 0:
                    updates["from_lat"] = loc["lat"]
                    updates["from_lon"] = loc["lon"]
                    break

        # Check to_address
        if not d.get("to_lat"):
            for label, loc in CONFIG["locations"].items():
                if label == d.get("to_address") and loc["lat"] != 0:
                    updates["to_lat"] = loc["lat"]
                    updates["to_lon"] = loc["lon"]
                    break

        if updates:
            doc.reference.update(updates)
            updated += 1

    return {"status": "backfilled", "trips_updated": updated}


@app.post("/trips/backfill-google-maps")
def backfill_google_maps():
    """Backfill Google Maps route distance for existing trips"""
    db = get_db()
    load_custom_locations()

    updated = 0
    skipped = 0
    errors = 0
    trips = list(db.collection("trips").stream())

    for doc in trips:
        d = doc.to_dict()

        # Skip if already has google_maps_km
        if d.get("google_maps_km") is not None:
            skipped += 1
            continue

        # Need lat/lon for both start and end
        from_lat = d.get("from_lat")
        from_lon = d.get("from_lon")
        to_lat = d.get("to_lat")
        to_lon = d.get("to_lon")

        if not all([from_lat, from_lon, to_lat, to_lon]):
            skipped += 1
            continue

        # Get Google Maps route distance
        try:
            google_maps_km = get_google_maps_route_distance(from_lat, from_lon, to_lat, to_lon)
            if google_maps_km is None:
                errors += 1
                continue

            distance_km = d.get("distance_km", 0)
            route_info = calculate_route_deviation(distance_km, google_maps_km)

            doc.reference.update({
                "google_maps_km": route_info["google_maps_km"],
                "route_deviation_percent": route_info["deviation_percent"],
                "route_flag": route_info["flag"],
            })
            updated += 1
            logger.info(f"Backfilled trip {d.get('id')}: {distance_km}km driven, {google_maps_km}km Google Maps")
        except Exception as e:
            logger.error(f"Error backfilling trip {d.get('id')}: {e}")
            errors += 1

    return {
        "status": "backfilled",
        "trips_updated": updated,
        "trips_skipped": skipped,
        "errors": errors,
    }


@app.get("/locations")
def get_locations():
    """Get all custom locations"""
    db = get_db()
    docs = db.collection("locations").stream()
    return [{"name": doc.id, **doc.to_dict()} for doc in docs]


@app.post("/locations")
def add_location(loc: CustomLocation):
    """Add a custom location (name a place) and update existing trips"""
    db = get_db()
    db.collection("locations").document(loc.name).set({
        "lat": loc.lat,
        "lng": loc.lng,
        "created_at": datetime.utcnow().isoformat(),
    })
    # Also add to runtime config for immediate use
    CONFIG["locations"][loc.name] = {
        "lat": loc.lat,
        "lon": loc.lng,
        "radius": 150,
        "is_business": True,  # Default to business
    }

    # Update existing trips within 150m radius
    updated = 0
    trips = db.collection("trips").stream()
    for doc in trips:
        d = doc.to_dict()
        updates = {}
        # Check from location
        if d.get("from_lat") and d.get("from_lon"):
            if haversine(loc.lat, loc.lng, d["from_lat"], d["from_lon"]) <= 150:
                updates["from_address"] = loc.name
        # Check to location
        if d.get("to_lat") and d.get("to_lon"):
            if haversine(loc.lat, loc.lng, d["to_lat"], d["to_lon"]) <= 150:
                updates["to_address"] = loc.name
        if updates:
            doc.reference.update(updates)
            updated += 1

    return {"status": "added", "name": loc.name, "trips_updated": updated}


@app.delete("/locations/{name}")
def delete_location(name: str):
    """Delete a custom location"""
    db = get_db()
    db.collection("locations").document(name).delete()
    CONFIG["locations"].pop(name, None)
    return {"status": "deleted"}


@app.get("/trips/{trip_id}", response_model=Trip)
def get_trip(trip_id: str):
    """Get single trip"""
    db = get_db()
    doc = db.collection("trips").document(trip_id).get()
    if not doc.exists:
        raise HTTPException(status_code=404, detail="Trip not found")
    return doc_to_trip(doc)


@app.patch("/trips/{trip_id}", response_model=Trip)
def update_trip(trip_id: str, update: TripUpdate):
    """Update trip fields"""
    db = get_db()
    ref = db.collection("trips").document(trip_id)
    doc = ref.get()

    if not doc.exists:
        raise HTTPException(status_code=404, detail="Trip not found")

    data = doc.to_dict()
    updates = {}

    if update.date is not None:
        updates["date"] = update.date
    if update.start_time is not None:
        updates["start_time"] = update.start_time
    if update.end_time is not None:
        updates["end_time"] = update.end_time
    if update.from_address is not None:
        updates["from_address"] = update.from_address
    if update.to_address is not None:
        updates["to_address"] = update.to_address
    if update.distance_km is not None:
        updates["distance_km"] = update.distance_km

    if update.trip_type:
        updates["trip_type"] = update.trip_type
        distance = update.distance_km if update.distance_km is not None else data["distance_km"]
        if update.trip_type == "B":
            updates["business_km"] = distance
            updates["private_km"] = 0
        elif update.trip_type == "P":
            updates["business_km"] = 0
            updates["private_km"] = distance

    if update.business_km is not None:
        updates["business_km"] = update.business_km
    if update.private_km is not None:
        updates["private_km"] = update.private_km
    if update.notes is not None:
        updates["notes"] = update.notes
    # route_flag can be set to None to clear it, so check if it was explicitly provided
    if "route_flag" in (update.model_dump(exclude_unset=True) or {}):
        updates["route_flag"] = update.route_flag
    if update.car_id is not None:
        updates["car_id"] = update.car_id

    if updates:
        ref.update(updates)

    return doc_to_trip(ref.get())


@app.delete("/trips/{trip_id}")
def delete_trip(trip_id: str):
    """Delete a trip"""
    db = get_db()
    ref = db.collection("trips").document(trip_id)
    if not ref.get().exists:
        raise HTTPException(status_code=404, detail="Trip not found")
    ref.delete()
    return {"status": "deleted"}


@app.get("/stats")
def get_stats(year: int | None = None, month: int | None = None, car_id: str | None = None, x_user_email: str | None = Header(None)):
    """Get statistics, optionally filtered by car"""
    user_id = get_user_from_header(x_user_email)
    db = get_db()
    query = db.collection("trips").where(filter=firestore.FieldFilter("user_id", "==", user_id))

    if year and month:
        start_dt = datetime(year, month, 1)
        end_dt = datetime(year + 1, 1, 1) if month == 12 else datetime(year, month + 1, 1)
        query = query.where(filter=firestore.FieldFilter("created_at", ">=", start_dt.isoformat()))
        query = query.where(filter=firestore.FieldFilter("created_at", "<", end_dt.isoformat()))

    total_km = 0.0
    business_km = 0.0
    private_km = 0.0
    trip_count = 0

    for doc in query.stream():
        data = doc.to_dict()
        # Filter by car_id if specified (exact match only)
        if car_id and data.get("car_id") != car_id:
            continue
        total_km += data.get("distance_km", 0)
        business_km += data.get("business_km", 0)
        private_km += data.get("private_km", 0)
        trip_count += 1

    return {
        "total_km": round(total_km, 1),
        "business_km": round(business_km, 1),
        "private_km": round(private_km, 1),
        "trip_count": trip_count,
    }


@app.post("/export")
def export_to_sheet(req: ExportRequest, x_user_email: str | None = Header(None)):
    """Export trips to Google Sheet"""
    import re

    

    # Extract spreadsheet ID from URL if full URL provided
    spreadsheet_id = req.spreadsheet_id
    if "docs.google.com" in spreadsheet_id:
        match = re.search(r"/d/([a-zA-Z0-9-_]+)", spreadsheet_id)
        if match:
            spreadsheet_id = match.group(1)
        else:
            raise HTTPException(status_code=400, detail="Invalid spreadsheet URL")

    creds, _ = default(scopes=["https://www.googleapis.com/auth/spreadsheets"])
    sheets = build("sheets", "v4", credentials=creds)

    db = get_db()

    # Build car name lookup map
    car_names = {}
    cars_ref = db.collection("users").document(user_id).collection("cars")
    for car_doc in cars_ref.stream():
        car_data = car_doc.to_dict()
        car_names[car_doc.id] = car_data.get("name", car_doc.id)

    # Query trips
    query = db.collection("trips").order_by("created_at")

    if req.year and req.month:
        start_dt = datetime(req.year, req.month, 1)
        end_dt = datetime(req.year + 1, 1, 1) if req.month == 12 else datetime(req.year, req.month + 1, 1)
        query = query.where(filter=firestore.FieldFilter("created_at", ">=", start_dt.isoformat()))
        query = query.where(filter=firestore.FieldFilter("created_at", "<", end_dt.isoformat()))

    docs = list(query.stream())

    # Filter by car_id if specified
    if req.car_id:
        docs = [doc for doc in docs if doc.to_dict().get("car_id") == req.car_id]

    headers = [
        "ID", "Datum", "Vertrektijd", "Aankomsttijd", "Van", "Naar",
        "Van Lat", "Van Lon", "Naar Lat", "Naar Lon",
        "Afstand (km)", "Type", "Zakelijk (km)", "Privé (km)",
        "Begin km-stand", "Eind km-stand", "Auto", "Notities", "Aangemaakt",
    ]

    def build_row(d: dict) -> list:
        car_id = d.get("car_id", "")
        car_name = car_names.get(car_id, car_id) if car_id else ""
        return [
            d.get("id", ""),
            d.get("date", ""),
            d.get("start_time", ""),
            d.get("end_time", ""),
            d.get("from_address", ""),
            d.get("to_address", ""),
            d.get("from_lat", ""),
            d.get("from_lon", ""),
            d.get("to_lat", ""),
            d.get("to_lon", ""),
            d.get("distance_km", 0),
            d.get("trip_type", ""),
            d.get("business_km", 0),
            d.get("private_km", 0),
            d.get("start_odo", 0),
            d.get("end_odo", 0),
            car_name,
            d.get("notes", ""),
            d.get("created_at", ""),
        ]

    if req.separate_sheets:
        # Group trips by car
        trips_by_car: dict[str, list] = {}
        for doc in docs:
            d = doc.to_dict()
            car_id = d.get("car_id", "")
            if car_id not in trips_by_car:
                trips_by_car[car_id] = []
            trips_by_car[car_id].append(d)

        # Get existing sheet names
        spreadsheet = sheets.spreadsheets().get(spreadsheetId=spreadsheet_id).execute()
        existing_sheets = {s["properties"]["title"] for s in spreadsheet.get("sheets", [])}

        total_rows = 0
        sheets_created = []

        for car_id, trips in trips_by_car.items():
            car_name = car_names.get(car_id, car_id) if car_id else "Onbekend"
            sheet_name = car_name[:31]  # Sheet name max 31 chars

            # Create sheet if it doesn't exist
            if sheet_name not in existing_sheets:
                sheets.spreadsheets().batchUpdate(
                    spreadsheetId=spreadsheet_id,
                    body={"requests": [{"addSheet": {"properties": {"title": sheet_name}}}]},
                ).execute()
                sheets_created.append(sheet_name)

            # Build rows for this car
            rows = [headers]
            for d in trips:
                rows.append(build_row(d))

            # Write to the car's sheet
            sheets.spreadsheets().values().update(
                spreadsheetId=spreadsheet_id,
                range=f"'{sheet_name}'!A1",
                valueInputOption="USER_ENTERED",
                body={"values": rows},
            ).execute()

            total_rows += len(rows) - 1

        return {
            "status": "exported",
            "rows": total_rows,
            "separate_sheets": True,
            "sheets_created": sheets_created,
            "cars": list(trips_by_car.keys()),
        }
    else:
        # Single sheet export
        rows = [headers]
        for doc in docs:
            d = doc.to_dict()
            rows.append(build_row(d))

        sheets.spreadsheets().values().update(
            spreadsheetId=spreadsheet_id,
            range="A1",
            valueInputOption="USER_ENTERED",
            body={"values": rows},
        ).execute()

        return {"status": "exported", "rows": len(rows) - 1}


# === Helper Functions ===


def doc_to_trip(doc) -> Trip:
    d = doc.to_dict()
    # Convert gps_trail dicts to GpsPoint objects
    gps_trail_data = d.get("gps_trail", [])
    gps_trail = [GpsPoint(lat=p["lat"], lng=p["lng"], timestamp=p.get("timestamp")) for p in gps_trail_data]
    return Trip(
        id=doc.id,
        date=d.get("date", ""),
        start_time=d.get("start_time", ""),
        end_time=d.get("end_time", ""),
        from_address=d.get("from_address", ""),
        to_address=d.get("to_address", ""),
        from_lat=d.get("from_lat"),
        from_lon=d.get("from_lon"),
        to_lat=d.get("to_lat"),
        to_lon=d.get("to_lon"),
        distance_km=d.get("distance_km", 0),
        trip_type=d.get("trip_type", "B"),
        business_km=d.get("business_km", 0),
        private_km=d.get("private_km", 0),
        start_odo=d.get("start_odo", 0),
        end_odo=d.get("end_odo", 0),
        notes=d.get("notes", ""),
        created_at=d.get("created_at", ""),
        car_id=d.get("car_id"),
        gps_trail=gps_trail,
        google_maps_km=d.get("google_maps_km"),
        route_deviation_percent=d.get("route_deviation_percent"),
        route_flag=d.get("route_flag"),
    )


def process_trip(start: dict, end: TripEvent) -> dict:
    """Process complete trip and save to Firestore"""
    start_loc = reverse_geocode(start["lat"], start["lon"])
    end_loc = reverse_geocode(end.lat, end.lon)
    distance = calculate_distance(start["lat"], start["lon"], end.lat, end.lon)

    if distance["distance_km"] < CONFIG["min_trip_km"]:
        return {"ignored": True}

    # Get Google Maps route distance for comparison
    google_maps_km = get_google_maps_route_distance(
        start["lat"], start["lon"],
        end.lat, end.lon
    )
    route_info = calculate_route_deviation(distance["distance_km"], google_maps_km)

    classification = classify_trip(start["timestamp"], start_loc, end_loc, distance["distance_km"])
    prev_odo = get_last_odometer()

    trip_id = generate_id()
    start_dt = datetime.fromisoformat(start["timestamp"].replace("Z", "+00:00"))
    end_dt = datetime.fromisoformat(end.timestamp.replace("Z", "+00:00"))

    trip_data = {
        "id": trip_id,
        "date": start_dt.strftime("%d-%m-%Y"),
        "start_time": start_dt.strftime("%H:%M"),
        "end_time": end_dt.strftime("%H:%M"),
        "from_address": start_loc["label"] or start_loc["address"],
        "to_address": end_loc["label"] or end_loc["address"],
        "from_lat": start_loc.get("lat"),
        "from_lon": start_loc.get("lon"),
        "to_lat": end_loc.get("lat"),
        "to_lon": end_loc.get("lon"),
        "distance_km": round(distance["distance_km"], 1),
        "trip_type": classification["type"],
        "business_km": round(classification["business_km"], 1),
        "private_km": round(classification["private_km"], 1),
        "start_odo": round(prev_odo, 1),
        "end_odo": round(prev_odo + distance["distance_km"], 1),
        "notes": "",
        "created_at": datetime.utcnow().isoformat(),
        "google_maps_km": route_info["google_maps_km"],
        "route_deviation_percent": route_info["deviation_percent"],
        "route_flag": route_info["flag"],
    }

    db = get_db()
    db.collection("trips").document(trip_id).set(trip_data)
    logger.info(f"Trip saved: {trip_id}")

    return trip_data


def get_last_odometer(user_id: str) -> float:
    db = get_db()
    query = db.collection("trips").where(
        filter=firestore.FieldFilter("user_id", "==", user_id)
    ).order_by("created_at", direction=firestore.Query.DESCENDING)
    docs = query.limit(1).stream()
    for doc in docs:
        return doc.to_dict().get("end_odo", CONFIG["start_odometer"])
    return CONFIG["start_odometer"]


def reverse_geocode(lat: float, lon: float, user_id: str | None = None) -> dict:
    # Load custom locations from Firestore
    load_custom_locations(user_id)

    for label, loc in CONFIG["locations"].items():
        if loc["lat"] == 0:
            continue
        if haversine(lat, lon, loc["lat"], loc["lon"]) <= loc["radius"]:
            return {"address": label, "label": label, "is_business": loc["is_business"], "lat": lat, "lon": lon}

    api_key = CONFIG["maps_api_key"]
    if not api_key:
        return {"address": f"{lat:.4f}, {lon:.4f}", "label": None, "is_business": None, "lat": lat, "lon": lon}

    try:
        url = f"https://maps.googleapis.com/maps/api/geocode/json?latlng={lat},{lon}&key={api_key}&language=nl"
        data = requests.get(url, timeout=10).json()
        if data["status"] == "OK" and data["results"]:
            parts = []
            for c in data["results"][0]["address_components"]:
                if "route" in c["types"]:
                    parts.insert(0, c["long_name"])
                if "locality" in c["types"]:
                    parts.append(c["long_name"])
            return {
                "address": ", ".join(parts) or f"{lat:.4f}, {lon:.4f}",
                "label": None,
                "is_business": None,
                "lat": lat,
                "lon": lon,
            }
    except Exception as e:
        logger.error(f"Geocode error: {e}")

    return {"address": f"{lat:.4f}, {lon:.4f}", "label": None, "is_business": None, "lat": lat, "lon": lon}


def calculate_distance(lat1: float, lon1: float, lat2: float, lon2: float) -> dict:
    api_key = CONFIG["maps_api_key"]
    if api_key:
        try:
            url = f"https://maps.googleapis.com/maps/api/directions/json?origin={lat1},{lon1}&destination={lat2},{lon2}&mode=driving&key={api_key}"
            data = requests.get(url, timeout=10).json()
            if data["status"] == "OK":
                return {"distance_km": data["routes"][0]["legs"][0]["distance"]["value"] / 1000}
        except Exception as e:
            logger.error(f"Directions error: {e}")

    return {"distance_km": haversine(lat1, lon1, lat2, lon2) * 1.3 / 1000}


def get_google_maps_route_distance(from_lat: float, from_lon: float, to_lat: float, to_lon: float) -> float | None:
    """Get the shortest driving route distance from Google Maps Directions API."""
    api_key = CONFIG["maps_api_key"]
    if not api_key:
        return None

    try:
        url = f"https://maps.googleapis.com/maps/api/directions/json?origin={from_lat},{from_lon}&destination={to_lat},{to_lon}&mode=driving&key={api_key}"
        data = requests.get(url, timeout=10).json()
        if data["status"] == "OK" and data.get("routes"):
            return data["routes"][0]["legs"][0]["distance"]["value"] / 1000
    except Exception as e:
        logger.error(f"Google Maps route distance error: {e}")

    return None


def calculate_route_deviation(driven_km: float, google_maps_km: float | None) -> dict:
    """
    Calculate how much longer the driven route was compared to Google Maps.
    Returns dict with deviation_percent and flag if significantly longer.
    """
    if google_maps_km is None or google_maps_km <= 0:
        return {"google_maps_km": None, "deviation_percent": None, "flag": None}

    # How much longer (in %) is the driven route vs Google Maps
    deviation_percent = ((driven_km - google_maps_km) / google_maps_km) * 100

    # Flag if driven route is >5% longer than Google Maps suggests
    flag = None
    if deviation_percent > 5:
        flag = "long_route"
        logger.info(f"Route flag: driven {driven_km}km vs Google Maps {google_maps_km}km ({deviation_percent:.1f}% longer)")

    return {
        "google_maps_km": round(google_maps_km, 1),
        "deviation_percent": round(deviation_percent, 1),
        "flag": flag,
    }


def haversine(lat1: float, lon1: float, lat2: float, lon2: float) -> float:
    R = 6371000
    p1, p2 = math.radians(lat1), math.radians(lat2)
    dp = math.radians(lat2 - lat1)
    dl = math.radians(lon2 - lon1)
    a = math.sin(dp / 2) ** 2 + math.cos(p1) * math.cos(p2) * math.sin(dl / 2) ** 2
    return R * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))


def classify_trip(
    timestamp: str, start_loc: dict, end_loc: dict, distance: float
) -> dict:
    """
    Classification logic:
    - Thuis ↔ Kantoor (commute) = Business
    - Kantoor → anywhere = Business
    - Thuis → anywhere on weekday = Business (assume client visit)
    - Weekend (and not involving office) = Private
    """
    dt = datetime.fromisoformat(timestamp.replace("Z", "+00:00"))
    is_weekend = dt.weekday() in CONFIG["private_days"]

    start_is_office = start_loc.get("label") == "Kantoor"
    end_is_office = end_loc.get("label") == "Kantoor"
    involves_office = start_is_office or end_is_office

    # If office is involved, always business
    if involves_office:
        return {"type": "B", "business_km": distance, "private_km": 0}

    # Weekend without office = private
    if is_weekend:
        return {"type": "P", "business_km": 0, "private_km": distance}

    # Weekday without office = assume business (client visit)
    return {"type": "B", "business_km": distance, "private_km": 0}


def generate_id() -> str:
    import random
    import string

    now = datetime.now()
    rand = "".join(random.choices(string.ascii_uppercase, k=3))
    return f"{now.strftime('%Y%m%d-%H%M')}-{rand}"


# =======================
# Car Management Endpoints (Multi-Car Support)
# =======================

def get_car_stats(user_id: str, car_id: str) -> tuple[int, float]:
    """Get trip count and total km for a car (exact match only)."""
    db = get_db()
    trips = db.collection("trips").where(
        filter=firestore.FieldFilter("user_id", "==", user_id)
    ).where(
        filter=firestore.FieldFilter("car_id", "==", car_id)
    ).stream()
    total_trips = 0
    total_km = 0.0
    for trip in trips:
        data = trip.to_dict()
        total_trips += 1
        total_km += data.get("distance_km", 0)
    return total_trips, total_km


@app.get("/cars")
def list_cars(x_user_email: str | None = Header(None)) -> list[Car]:
    """List all cars for the user"""
    user_id = get_user_from_header(x_user_email)
    db = get_db()
    cars_ref = db.collection("users").document(user_id).collection("cars")
    cars = []

    for doc in cars_ref.order_by("created_at").stream():
        data = doc.to_dict()
        total_trips, total_km = get_car_stats(user_id, doc.id)
        cars.append(Car(
            id=doc.id,
            name=data.get("name", ""),
            brand=data.get("brand", "other"),
            color=data.get("color", "#3B82F6"),
            icon=data.get("icon", "car"),
            is_default=data.get("is_default", False),
            carplay_device_id=data.get("carplay_device_id"),
            created_at=data.get("created_at"),
            last_used=data.get("last_used"),
            total_trips=total_trips,
            total_km=round(total_km, 1),
        ))

    return cars


@app.post("/cars")
def create_car(car: CarCreate, x_user_email: str | None = Header(None)):
    """Create a new car"""
    user_id = get_user_from_header(x_user_email)
    db = get_db()
    cars_ref = db.collection("users").document(user_id).collection("cars")

    # Check if this is the first car (make it default)
    existing = list(cars_ref.limit(1).stream())
    is_first = len(existing) == 0

    # Create car document
    car_id = db.collection("_").document().id  # Generate unique ID
    now = datetime.utcnow().isoformat()

    car_data = {
        "name": car.name,
        "brand": car.brand,
        "color": car.color,
        "icon": car.icon,
        "is_default": is_first,  # First car is default
        "start_odometer": car.start_odometer,
        "created_at": now,
        "last_used": None,
    }

    cars_ref.document(car_id).set(car_data)

    return Car(
        id=car_id,
        name=car.name,
        brand=car.brand,
        color=car.color,
        icon=car.icon,
        is_default=is_first,
        start_odometer=car.start_odometer,
        created_at=now,
        total_trips=0,
        total_km=0,
    )


@app.get("/cars/{car_id}")
def get_car(car_id: str, x_user_email: str | None = Header(None)):
    """Get a single car"""
    user_id = get_user_from_header(x_user_email)
    db = get_db()
    car_ref = db.collection("users").document(user_id).collection("cars").document(car_id)
    doc = car_ref.get()

    if not doc.exists:
        raise HTTPException(status_code=404, detail="Car not found")

    data = doc.to_dict()
    total_trips, total_km = get_car_stats(user_id, car_id)

    return Car(
        id=doc.id,
        name=data.get("name", ""),
        brand=data.get("brand", "other"),
        color=data.get("color", "#3B82F6"),
        icon=data.get("icon", "car"),
        is_default=data.get("is_default", False),
        carplay_device_id=data.get("carplay_device_id"),
        created_at=data.get("created_at"),
        last_used=data.get("last_used"),
        total_trips=total_trips,
        total_km=round(total_km, 1),
    )


@app.patch("/cars/{car_id}")
def update_car(car_id: str, update: CarUpdate, x_user_email: str | None = Header(None)):
    """Update a car"""
    user_id = get_user_from_header(x_user_email)
    db = get_db()
    cars_ref = db.collection("users").document(user_id).collection("cars")
    car_ref = cars_ref.document(car_id)
    doc = car_ref.get()

    if not doc.exists:
        raise HTTPException(status_code=404, detail="Car not found")

    updates = {}
    if update.name is not None:
        updates["name"] = update.name
    if update.brand is not None:
        updates["brand"] = update.brand
    if update.color is not None:
        updates["color"] = update.color
    if update.icon is not None:
        updates["icon"] = update.icon
    if update.carplay_device_id is not None:
        updates["carplay_device_id"] = update.carplay_device_id
    if update.start_odometer is not None:
        updates["start_odometer"] = update.start_odometer

    # Handle is_default - unset others if setting to true
    if update.is_default is True:
        # Unset all other cars as default
        for other_doc in cars_ref.where("is_default", "==", True).stream():
            if other_doc.id != car_id:
                cars_ref.document(other_doc.id).update({"is_default": False})
        updates["is_default"] = True
    elif update.is_default is False:
        updates["is_default"] = False

    if updates:
        car_ref.update(updates)

    return {"status": "updated", "car_id": car_id}


@app.delete("/cars/{car_id}")
def delete_car(car_id: str, x_user_email: str | None = Header(None)):
    """Delete a car (trips remain but car_id becomes null)"""
    user_id = get_user_from_header(x_user_email)
    db = get_db()
    cars_ref = db.collection("users").document(user_id).collection("cars")
    car_ref = cars_ref.document(car_id)
    doc = car_ref.get()

    if not doc.exists:
        raise HTTPException(status_code=404, detail="Car not found")

    # Check if this is the last car
    all_cars = list(cars_ref.stream())
    if len(all_cars) <= 1:
        raise HTTPException(status_code=400, detail="Cannot delete last car")

    was_default = doc.to_dict().get("is_default", False)

    # Delete the car
    car_ref.delete()

    # If it was default, make another car default
    if was_default:
        remaining = list(cars_ref.limit(1).stream())
        if remaining:
            cars_ref.document(remaining[0].id).update({"is_default": True})

    # Update trips that had this car_id to null
    trips_col = db.collection("trips")
    for trip in trips_col.where(filter=firestore.FieldFilter("user_id", "==", user_id)).where(filter=firestore.FieldFilter("car_id", "==", car_id)).stream():
        trips_col.document(trip.id).update({"car_id": None})

    return {"status": "deleted"}


@app.put("/cars/{car_id}/credentials")
def save_car_credentials(car_id: str, creds: CarCredentials, x_user_email: str | None = Header(None)):
    """Save API credentials for a specific car"""
    user_id = get_user_from_header(x_user_email)
    db = get_db()
    car_ref = db.collection("users").document(user_id).collection("cars").document(car_id)
    doc = car_ref.get()

    if not doc.exists:
        raise HTTPException(status_code=404, detail="Car not found")

    # Store credentials in a subcollection for security
    creds_ref = car_ref.collection("credentials").document("api")
    creds_ref.set({
        "brand": creds.brand,
        "username": creds.username,
        "password": creds.password,
        "country": creds.country,
        "locale": creds.locale,
        "spin": creds.spin,
        "start_odometer": creds.start_odometer,
        "updated_at": datetime.utcnow().isoformat(),
    })

    # Update car brand to match credentials
    car_ref.update({"brand": creds.brand})

    return {"status": "saved"}


# ============ Tesla OAuth Endpoints ============

@app.get("/cars/{car_id}/tesla/auth-url")
def get_tesla_auth_url(car_id: str, callback_url: str, x_user_email: str | None = Header(None)):
    """Get Tesla OAuth authorization URL for user to login"""
    from car_providers import TeslaProvider

    user_id = get_user_from_header(x_user_email)
    db = get_db()
    car_ref = db.collection("users").document(user_id).collection("cars").document(car_id)
    doc = car_ref.get()

    if not doc.exists:
        raise HTTPException(status_code=404, detail="Car not found")

    # Store the email temporarily for the OAuth flow
    email = x_user_email or user_id

    provider = TeslaProvider(email=email)
    auth_url = provider.get_authorization_url(callback_url)

    if not auth_url:
        return {"status": "already_authorized", "auth_url": None}

    # Store email in credentials for later use
    creds_ref = car_ref.collection("credentials").document("api")
    creds_ref.set({
        "brand": "tesla",
        "username": email,  # Email is used as identifier
        "password": "",  # No password for Tesla OAuth
        "oauth_pending": True,
        "updated_at": datetime.utcnow().isoformat(),
    }, merge=True)

    return {"status": "authorization_required", "auth_url": auth_url}


@app.post("/cars/{car_id}/tesla/callback")
def complete_tesla_auth(car_id: str, callback_url: str, x_user_email: str | None = Header(None)):
    """Complete Tesla OAuth flow with the callback URL containing the auth code"""
    from car_providers import TeslaProvider

    user_id = get_user_from_header(x_user_email)
    db = get_db()
    car_ref = db.collection("users").document(user_id).collection("cars").document(car_id)
    doc = car_ref.get()

    if not doc.exists:
        raise HTTPException(status_code=404, detail="Car not found")

    # Get email from credentials
    creds_doc = car_ref.collection("credentials").document("api").get()
    if not creds_doc.exists:
        raise HTTPException(status_code=400, detail="No pending Tesla authorization")

    creds = creds_doc.to_dict()
    email = creds.get("username", x_user_email or user_id)

    provider = TeslaProvider(email=email)
    success = provider.complete_authorization(callback_url)

    if not success:
        raise HTTPException(status_code=400, detail="Tesla authorization failed")

    # Update credentials to mark as complete
    car_ref.collection("credentials").document("api").update({
        "oauth_pending": False,
        "oauth_completed": True,
        "updated_at": datetime.utcnow().isoformat(),
    })

    # Update car brand
    car_ref.update({"brand": "tesla"})

    # Try to get vehicle data to confirm it works
    try:
        data = provider.get_data()
        provider.disconnect()
        return {
            "status": "success",
            "vin": data.vin,
            "odometer_km": data.odometer_km,
            "battery_level": data.battery_level,
        }
    except Exception as e:
        return {"status": "success", "message": "Authorization complete, but could not fetch vehicle data yet"}


@app.post("/cars/{car_id}/credentials/test")
def test_car_credentials(car_id: str, creds: CarCredentials, x_user_email: str | None = Header(None)):
    """Test car API credentials before saving"""
    user_id = get_user_from_header(x_user_email)
    db = get_db()
    car_ref = db.collection("users").document(user_id).collection("cars").document(car_id)
    doc = car_ref.get()

    if not doc.exists:
        raise HTTPException(status_code=404, detail="Car not found")

    try:
        from car_providers import VWGroupProvider, RenaultProvider, VW_GROUP_BRANDS

        # Test connection using car provider
        if creds.brand == "renault":
            provider = RenaultProvider(
                username=creds.username,
                password=creds.password,
                locale=creds.locale or "nl_NL",
            )
        elif creds.brand in VW_GROUP_BRANDS:
            provider = VWGroupProvider(
                brand=creds.brand,
                username=creds.username,
                password=creds.password,
                country=creds.country or "NL",
                spin=creds.spin,
            )
        else:
            raise HTTPException(status_code=400, detail=f"Unsupported brand: {creds.brand}")

        data = provider.get_data()
        provider.disconnect()

        return {
            "status": "success",
            "vin": data.vin,
            "odometer_km": data.odometer_km,
            "battery_level": data.battery_level,
        }
    except Exception as e:
        raise HTTPException(status_code=400, detail=f"Connection failed: {str(e)}")


@app.get("/cars/{car_id}/data")
def get_car_data_by_id(car_id: str, x_user_email: str | None = Header(None)):
    """Get live car data for a specific car using its credentials"""
    from car_providers import VWGroupProvider, RenaultProvider, TeslaProvider, VW_GROUP_BRANDS

    user_id = get_user_from_header(x_user_email)
    db = get_db()
    car_ref = db.collection("users").document(user_id).collection("cars").document(car_id)
    doc = car_ref.get()

    if not doc.exists:
        raise HTTPException(status_code=404, detail="Car not found")

    car_data = doc.to_dict()

    # Get credentials from subcollection
    creds_doc = car_ref.collection("credentials").document("api").get()
    if not creds_doc.exists:
        raise HTTPException(status_code=400, detail="Car has no API credentials configured")

    creds = creds_doc.to_dict()
    brand = creds.get("brand", car_data.get("brand", "")).lower()

    # Tesla uses OAuth, others need username/password
    if brand == "tesla":
        if not creds.get("oauth_completed"):
            raise HTTPException(status_code=400, detail="Tesla authorization not complete. Please authorize first.")
    elif not creds.get("username") or not creds.get("password"):
        raise HTTPException(status_code=400, detail="Car has no API credentials configured")

    try:
        if brand == "tesla":
            provider = TeslaProvider(
                email=creds.get("username", x_user_email),
            )
        elif brand == "renault":
            provider = RenaultProvider(
                username=creds["username"],
                password=creds["password"],
                locale=creds.get("locale", "nl_NL"),
                vin=creds.get("vin"),
            )
        elif brand in VW_GROUP_BRANDS:
            provider = VWGroupProvider(
                brand=brand,
                username=creds["username"],
                password=creds["password"],
                country=creds.get("country", "NL"),
                spin=creds.get("spin"),
            )
        else:
            raise HTTPException(status_code=400, detail=f"Unknown brand: {brand}")

        data = provider.get_data()
        provider.disconnect()

        # Extract extra data from raw_data
        raw = data.raw_data or {}

        # Initialize extra fields
        battery_temp_celsius = None
        climate_state = None
        climate_target_temp = None
        seat_heating = None
        window_heating = None
        connection_state = None
        lights_state = None

        # Tesla-specific parsing
        if brand == 'tesla':
            if 'climate_state' in raw:
                clim = raw['climate_state']
                climate_state = 'on' if clim.get('is_climate_on') else 'off'
                climate_target_temp = clim.get('driver_temp_setting')
                seat_heating = clim.get('seat_heater_left', 0) > 0

        # Renault-specific parsing
        elif 'renault' in raw:
            renault_data = raw['renault']
            battery_temp_celsius = renault_data.get('battery_temp_celsius')
            hvac_status = renault_data.get('hvac_status')
            if hvac_status:
                climate_state = 'on' if hvac_status in ('on', 'pending', True) else 'off'

        # Audi/VW-specific parsing
        else:
            if 'drives' in raw and 'primary' in raw['drives'] and 'battery' in raw['drives']['primary']:
                batt = raw['drives']['primary']['battery']
                if 'temperature' in batt and 'val' in batt['temperature']:
                    battery_temp_celsius = round(batt['temperature']['val'] - 273.15, 1)

            if 'climatization' in raw:
                clim = raw['climatization']
                if 'state' in clim and 'val' in clim['state']:
                    climate_state = clim['state']['val']
                if 'settings' in clim:
                    settings = clim['settings']
                    if 'target_temperature' in settings and 'val' in settings['target_temperature']:
                        climate_target_temp = settings['target_temperature']['val']
                    if 'seat_heating' in settings and 'val' in settings['seat_heating']:
                        seat_heating = settings['seat_heating']['val']
                    if 'window_heating' in settings and 'val' in settings['window_heating']:
                        window_heating = settings['window_heating']['val']

            if 'connection_state' in raw and 'val' in raw['connection_state']:
                connection_state = raw['connection_state']['val']

            if 'lights' in raw and 'light_state' in raw['lights'] and 'val' in raw['lights']['light_state']:
                lights_state = raw['lights']['light_state']['val']

        return {
            "car_id": car_id,
            "car_name": car_data.get("name", ""),
            "brand": brand,
            "vin": data.vin,
            "odometer_km": data.odometer_km,
            "latitude": data.latitude,
            "longitude": data.longitude,
            "state": data.state,
            "battery_level": data.battery_level,
            "range_km": data.range_km,
            "is_charging": data.is_charging,
            "is_plugged_in": data.is_plugged_in,
            "charging_power_kw": data.charging_power_kw,
            "charging_remaining_minutes": data.charging_remaining_minutes,
            "battery_temp_celsius": battery_temp_celsius,
            "climate_state": climate_state,
            "climate_target_temp": climate_target_temp,
            "seat_heating": seat_heating,
            "window_heating": window_heating,
            "connection_state": connection_state,
            "lights_state": lights_state,
            "fetched_at": datetime.now(tz=timezone.utc).isoformat(),
        }
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to fetch car data: {str(e)}")


@app.get("/cars/{car_id}/stats")
def get_car_statistics(car_id: str, x_user_email: str | None = Header(None)):
    """Get detailed statistics for a car"""
    user_id = get_user_from_header(x_user_email)
    db = get_db()
    car_ref = db.collection("users").document(user_id).collection("cars").document(car_id)
    doc = car_ref.get()

    if not doc.exists:
        raise HTTPException(status_code=404, detail="Car not found")

    trips = db.collection("trips").where(
        filter=firestore.FieldFilter("user_id", "==", user_id)
    ).where(
        filter=firestore.FieldFilter("car_id", "==", car_id)
    ).stream()

    total_trips = 0
    total_km = 0.0
    business_km = 0.0
    private_km = 0.0

    for trip in trips:
        data = trip.to_dict()
        total_trips += 1
        total_km += data.get("distance_km", 0)
        business_km += data.get("business_km", 0)
        private_km += data.get("private_km", 0)

    return {
        "car_id": car_id,
        "trip_count": total_trips,
        "total_km": round(total_km, 1),
        "business_km": round(business_km, 1),
        "private_km": round(private_km, 1),
    }


def get_default_car_id(user_id: str) -> str | None:
    """Get the default car ID for a user"""
    db = get_db()
    cars_ref = db.collection("users").document(user_id).collection("cars")

    # Try to find default car
    default_cars = list(cars_ref.where("is_default", "==", True).limit(1).stream())
    if default_cars:
        return default_cars[0].id

    # Fall back to first car
    any_car = list(cars_ref.limit(1).stream())
    if any_car:
        return any_car[0].id

    return None


def get_car_id_by_device(user_id: str, device_id: str) -> str | None:
    """Get car ID by matching carplay_device_id"""
    if not device_id:
        return None
    db = get_db()
    cars_ref = db.collection("users").document(user_id).collection("cars")
    matching_cars = list(cars_ref.where("carplay_device_id", "==", device_id).limit(1).stream())
    if matching_cars:
        logger.info(f"Found car {matching_cars[0].id} for device_id {device_id}")
        return matching_cars[0].id
    logger.info(f"No car found for device_id {device_id}")
    return None


def get_car_start_odometer(user_id: str, car_id: str | None) -> float:
    """Get start_odometer for a specific car, falls back to CONFIG"""
    if car_id:
        db = get_db()
        car_doc = db.collection("users").document(user_id).collection("cars").document(car_id).get()
        if car_doc.exists:
            car_data = car_doc.to_dict()
            start_odo = car_data.get("start_odometer", 0)
            if start_odo > 0:
                return start_odo
    # Final fallback to global CONFIG
    return CONFIG.get("start_odometer", 0)


def update_car_last_used(user_id: str, car_id: str):
    """Update the last_used timestamp for a car"""
    if not car_id:
        return
    db = get_db()
    car_ref = db.collection("users").document(user_id).collection("cars").document(car_id)
    if car_ref.get().exists:
        car_ref.update({"last_used": datetime.utcnow().isoformat()})


class CarTestRequest(BaseModel):
    brand: str = "audi"
    username: str
    password: str
    country: str = "NL"


@app.post("/car/test")
def test_car_credentials(request: CarTestRequest):
    """Test car credentials directly without saving"""
    from car_providers import VWGroupProvider, RenaultProvider, VW_GROUP_BRANDS

    try:
        brand = request.brand.lower()
        if brand == "renault":
            provider = RenaultProvider(
                username=request.username,
                password=request.password,
                locale="nl_NL",
                vin=None,
            )
        elif brand in VW_GROUP_BRANDS:
            provider = VWGroupProvider(
                brand=brand,
                username=request.username,
                password=request.password,
                country=request.country,
                spin="",
            )
        else:
            provider = VWGroupProvider(
                brand=brand,
                username=request.username,
                password=request.password,
                country=request.country,
                spin="",
            )

        success = provider.connect()
        if success:
            data = provider.get_data()
            provider.disconnect()
            return {
                "status": "success",
                "brand": provider.brand,
                "vin": data.vin,
                "odometer_km": data.odometer_km,
                "battery_level": data.battery_level,
            }
        else:
            provider.disconnect()
            return {"status": "failed", "error": "Login mislukt"}
    except Exception as e:
        logger.error(f"Car test error: {e}")
        return {"status": "error", "error": str(e)}


# === Trip Safety Net ===

STALE_TRIP_HOURS = 2  # Trips with no activity for 2+ hours are considered stale


@app.get("/audi/odometer-now")
def get_current_odometer(user: str):
    """Debug: get current odometer for a user's cars"""
    db = get_db()
    cars = get_cars_with_credentials(user)
    results = []
    for car_info in cars:
        # Get car doc for start_odometer
        car_doc = db.collection("users").document(user).collection("cars").document(car_info["car_id"]).get()
        car_data = car_doc.to_dict() if car_doc.exists else {}

        status = check_car_driving_status(car_info)
        if status:
            results.append({
                "car_id": car_info["car_id"],
                "name": status.get("name"),
                "current_odometer": status.get("odometer"),
                "start_odometer": car_data.get("start_odometer", 0),
                "state": status.get("state"),
                "is_parked": status.get("is_parked"),
            })
    return {"cars": results}


@app.get("/audi/check-trip")
def check_stale_trips():
    """Safety net: called periodically to recover stale/orphaned trips."""
    active_trips = get_all_active_trips()

    if not active_trips:
        logger.info("Safety net: no active trips")
        return {"status": "no_active_trips", "processed": 0}

    now = datetime.utcnow()
    results = []

    for user_id, cache in active_trips:
        # Check if trip is stale (no recent GPS events)
        gps_events = cache.get("gps_events", [])
        end_triggered = cache.get("end_triggered")

        if not gps_events:
            # No GPS events at all - cancel
            logger.info(f"Safety net: cancelling trip for {user_id} - no GPS events")
            set_trip_cache(None, user_id)
            results.append({"user": user_id, "action": "cancelled", "reason": "no_gps_events"})
            continue

        # Check last activity time
        last_event = gps_events[-1]
        last_time = datetime.fromisoformat(last_event["timestamp"].replace("Z", "+00:00")).replace(tzinfo=None)
        hours_since_activity = (now - last_time).total_seconds() / 3600

        # Trip is stale if: end was triggered OR no activity for 2+ hours
        is_stale = end_triggered or hours_since_activity >= STALE_TRIP_HOURS

        if not is_stale:
            results.append({"user": user_id, "action": "skipped", "reason": "still_active", "hours_since": round(hours_since_activity, 1)})
            continue

        logger.info(f"Safety net: recovering stale trip for {user_id} (hours={hours_since_activity:.1f}, end_triggered={end_triggered})")

        # Try to finalize the trip
        start_odo = cache.get("start_odo")
        assigned_car_id = cache.get("car_id")
        timestamp = now.isoformat() + "Z"

        # If we never got odometer, try to get it now
        if start_odo is None or not assigned_car_id:
            driving_car = find_driving_car(user_id)
            if driving_car:
                cache["car_id"] = driving_car["car_id"]
                cache["car_name"] = driving_car["name"]
                cache["start_odo"] = driving_car["odometer"]
                start_odo = driving_car["odometer"]
                assigned_car_id = driving_car["car_id"]
                if driving_car.get("lat") and driving_car.get("lng"):
                    cache["audi_gps"] = {"lat": driving_car["lat"], "lng": driving_car["lng"], "timestamp": timestamp}

        if not assigned_car_id or start_odo is None:
            # Can't recover - cancel
            logger.info(f"Safety net: cancelling trip for {user_id} - no car/odometer data")
            set_trip_cache(None, user_id)
            results.append({"user": user_id, "action": "cancelled", "reason": "no_odometer_data"})
            continue

        # Get current car status for end odometer
        cars = get_cars_with_credentials(user_id)
        car_info = next((c for c in cars if c["car_id"] == assigned_car_id), None)

        if not car_info:
            logger.info(f"Safety net: cancelling trip for {user_id} - car not found")
            set_trip_cache(None, user_id)
            results.append({"user": user_id, "action": "cancelled", "reason": "car_not_found"})
            continue

        car_status = check_car_driving_status(car_info)
        if not car_status:
            logger.warning(f"Safety net: couldn't get car status for {user_id}")
            results.append({"user": user_id, "action": "error", "reason": "car_status_unavailable"})
            continue

        current_odo = car_status["odometer"]
        car_lat = car_status.get("lat")
        car_lng = car_status.get("lng")

        if car_lat and car_lng:
            cache["audi_gps"] = {"lat": car_lat, "lng": car_lng, "timestamp": timestamp}

        total_km = current_odo - start_odo
        car_gps = cache.get("audi_gps")
        start_gps = gps_events[0]

        if total_km <= 0:
            logger.info(f"Safety net: skipping trip for {user_id} - {total_km} km (zero or negative)")
            set_trip_cache(None, user_id)
            results.append({"user": user_id, "action": "skipped", "reason": "zero_or_negative_km"})
            continue

        if not car_gps:
            # Use last GPS event as fallback
            car_gps = gps_events[-1]

        # Finalize the trip
        logger.info(f"Safety net: finalizing trip for {user_id}, {total_km} km")
        trip_result = finalize_trip_from_audi(
            start_gps=start_gps,
            end_gps=car_gps,
            start_odo=start_odo,
            end_odo=current_odo,
            start_time=cache.get("start_time"),
            gps_trail=cache.get("gps_trail", []),
            user_id=user_id,
            car_id=assigned_car_id,
        )

        set_trip_cache(None, user_id)
        results.append({"user": user_id, "action": "finalized", "km": total_km, "trip_id": trip_result.get("id")})

    return {"status": "completed", "processed": len(results), "results": results}


def finalize_trip_from_gps(gps_events: list, start_odo: float, end_odo: float, start_time: str) -> dict:
    """Finalize trip using GPS events and odometer readings."""
    # Sort GPS events by timestamp
    gps_events = sorted(gps_events, key=lambda x: x["timestamp"])

    # Filter to non-skip locations for start/end determination
    non_skip_events = [e for e in gps_events if not e.get("is_skip")]

    # Use non-skip events if available, otherwise fall back to all events
    if len(non_skip_events) >= 2:
        start_gps = non_skip_events[0]
        end_gps = non_skip_events[-1]
    else:
        # Fallback: use first and last of all events
        start_gps = gps_events[0]
        end_gps = gps_events[-1]

    # Geocode start and end
    start_loc = reverse_geocode(start_gps["lat"], start_gps["lng"])
    end_loc = reverse_geocode(end_gps["lat"], end_gps["lng"])

    # Distance from odometer (ground truth)
    distance_km = end_odo - start_odo

    # Get Google Maps route distance for comparison
    google_maps_km = get_google_maps_route_distance(
        start_gps["lat"], start_gps["lng"],
        end_gps["lat"], end_gps["lng"]
    )
    route_info = calculate_route_deviation(distance_km, google_maps_km)

    # Parse timestamps
    start_dt = datetime.fromisoformat(start_time.replace("Z", "+00:00"))
    end_dt = datetime.fromisoformat(end_gps["timestamp"].replace("Z", "+00:00"))

    # Classify trip
    classification = classify_trip(start_time, start_loc, end_loc, distance_km)

    trip_id = generate_id()
    trip_data = {
        "id": trip_id,
        "date": start_dt.strftime("%d-%m-%Y"),
        "start_time": start_dt.strftime("%H:%M"),
        "end_time": end_dt.strftime("%H:%M"),
        "from_address": start_loc["label"] or start_loc["address"],
        "to_address": end_loc["label"] or end_loc["address"],
        "from_lat": start_loc.get("lat"),
        "from_lon": start_loc.get("lon"),
        "to_lat": end_loc.get("lat"),
        "to_lon": end_loc.get("lon"),
        "distance_km": round(distance_km, 1),
        "trip_type": classification["type"],
        "business_km": round(classification["business_km"], 1),
        "private_km": round(classification["private_km"], 1),
        "start_odo": round(start_odo, 1),
        "end_odo": round(end_odo, 1),
        "notes": "",
        "created_at": datetime.utcnow().isoformat(),
        "car_id": "business_audi",  # We know it's the Audi because odometer moved
        "google_maps_km": route_info["google_maps_km"],
        "route_deviation_percent": route_info["deviation_percent"],
        "route_flag": route_info["flag"],
    }

    db = get_db()
    db.collection("trips").document(trip_id).set(trip_data)
    logger.info(f"Trip finalized from GPS: {trip_id}, {distance_km} km (Google Maps: {google_maps_km} km)")

    return trip_data


def finalize_trip_from_audi(start_gps: dict, end_gps: dict, start_odo: float, end_odo: float, start_time: str, user_id: str, gps_trail: list = None, car_id: str | None = None) -> dict:
    """Finalize trip using iPhone start GPS, Audi end GPS, and odometer."""
    if gps_trail is None:
        gps_trail = []
    # Geocode start (from iPhone) and end (from Audi)
    start_loc = reverse_geocode(start_gps["lat"], start_gps["lng"], user_id)
    end_loc = reverse_geocode(end_gps["lat"], end_gps["lng"], user_id)

    # Distance from odometer (ground truth)
    distance_km = end_odo - start_odo

    # Get Google Maps route distance for comparison
    google_maps_km = get_google_maps_route_distance(
        start_gps["lat"], start_gps["lng"],
        end_gps["lat"], end_gps["lng"]
    )
    route_info = calculate_route_deviation(distance_km, google_maps_km)

    # Parse timestamps
    start_dt = datetime.fromisoformat(start_time.replace("Z", "+00:00"))
    end_dt = datetime.fromisoformat(end_gps["timestamp"].replace("Z", "+00:00"))

    # Classify trip
    classification = classify_trip(start_time, start_loc, end_loc, distance_km)

    # Use provided car_id, fall back to default car, or "unknown"
    effective_car_id = car_id or get_default_car_id(user_id) or "unknown"

    trip_id = generate_id()
    trip_data = {
        "id": trip_id,
        "user_id": user_id,
        "date": start_dt.strftime("%d-%m-%Y"),
        "start_time": start_dt.strftime("%H:%M"),
        "end_time": end_dt.strftime("%H:%M"),
        "from_address": start_loc["label"] or start_loc["address"],
        "to_address": end_loc["label"] or end_loc["address"],
        "from_lat": start_loc.get("lat"),
        "from_lon": start_loc.get("lon"),
        "to_lat": end_loc.get("lat"),
        "to_lon": end_loc.get("lon"),
        "distance_km": round(distance_km, 1),
        "trip_type": classification["type"],
        "business_km": round(classification["business_km"], 1),
        "private_km": round(classification["private_km"], 1),
        "start_odo": round(start_odo, 1),
        "end_odo": round(end_odo, 1),
        "notes": "",
        "created_at": datetime.utcnow().isoformat(),
        "car_id": effective_car_id,
        "gps_trail": gps_trail,  # Route for Google Maps display
        "google_maps_km": route_info["google_maps_km"],
        "route_deviation_percent": route_info["deviation_percent"],
        "route_flag": route_info["flag"],
    }

    db = get_db()
    db.collection("trips").document(trip_id).set(trip_data)
    logger.info(f"Trip finalized from Audi: {trip_id}, {distance_km} km (Google Maps: {google_maps_km} km), {start_loc['label']} -> {end_loc['label']}, {len(gps_trail)} GPS points for {user_id}")

    return trip_data


@app.get("/audi/compare")
async def compare_odometer(car_id: str | None = None, x_user_email: str | None = Header(None)):
    """Compare car odometer with calculated trips - returns data for visualization"""
    user_id = get_user_from_header(x_user_email)

    db = get_db()

    # Get start_odometer for specific car or fallback to user settings
    start_odo = get_car_start_odometer(user_id, car_id)

    # Get user's odometer readings
    readings_docs = db.collection("users").document(user_id).collection("odometer_readings").order_by("created_at").stream()
    odometer_readings = []
    for doc in readings_docs:
        d = doc.to_dict()
        if d.get("odometer_km"):
            odometer_readings.append({
                "timestamp": d.get("created_at") or d.get("fetched_at"),
                "odometer_km": d["odometer_km"],
            })

    # Get user's trips sorted by actual trip date
    trips_query = db.collection("trips").where("user_id", "==", user_id)
    if car_id:
        trips_query = trips_query.where("car_id", "==", car_id)
    trips_docs = list(trips_query.stream())

    # Parse date (dd-mm-yyyy) and time to create proper datetime for sorting
    def parse_trip_datetime(d):
        try:
            date_str = d.get("date", "01-01-2025")
            time_str = d.get("start_time", "00:00")
            parts = date_str.split("-")
            if len(parts) == 3:
                day, month, year = parts
                return f"{year}-{month}-{day}T{time_str}:00"
        except:
            pass
        return d.get("created_at", "2025-01-01T00:00:00")

    # Sort by actual trip date
    trips_data = [(doc, doc.to_dict()) for doc in trips_docs]
    trips_data.sort(key=lambda x: parse_trip_datetime(x[1]))

    trips_timeline = []
    running_total = start_odo

    for doc, d in trips_data:
        distance = d.get("distance_km", 0)
        running_total += distance
        trips_timeline.append({
            "timestamp": parse_trip_datetime(d),  # Use actual trip datetime
            "date": d.get("date"),
            "trip_id": d.get("id"),
            "distance_km": distance,
            "cumulative_km": round(running_total, 1),
            "from": d.get("from_address"),
            "to": d.get("to_address"),
        })

    # Calculate current comparison
    latest_reading = odometer_readings[-1] if odometer_readings else None
    calculated_total = running_total

    comparison = None
    warnings = []

    if latest_reading:
        actual = latest_reading["odometer_km"]
        diff = actual - calculated_total
        diff_percent = (diff / actual * 100) if actual > 0 else 0

        comparison = {
            "actual_odometer_km": actual,
            "calculated_km": round(calculated_total, 1),
            "difference_km": round(diff, 1),
            "difference_percent": round(diff_percent, 2),
            "status": "ok" if abs(diff_percent) <= 2 else "warning",
            "reading_timestamp": latest_reading["timestamp"],
        }

        if abs(diff_percent) > 2:
            warnings.append({
                "type": "deviation",
                "message": f"Afwijking {diff_percent:.1f}% ({diff:.1f} km) - meer dan 2% toegestaan",
                "suggestion": "Controleer of alle ritten zijn gelogd" if diff > 0 else "Controleer afstanden van gelogde ritten",
            })

    return {
        "car_id": car_id,
        "start_odometer": start_odo,
        "trips_timeline": trips_timeline,
        "odometer_readings": odometer_readings,
        "comparison": comparison,
        "warnings": warnings,
    }


if __name__ == "__main__":
    import uvicorn

    uvicorn.run(app, host="0.0.0.0", port=8080)
