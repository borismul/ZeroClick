"""
mileage-tracker API - Firestore + Export to Sheets

This is the main entry point for the FastAPI application.
All business logic has been refactored into:
- models/   - Pydantic models
- auth/     - Authentication (Google OAuth, middleware)
- services/ - Business logic
- routes/   - API endpoints
- utils/    - Utility functions
- config.py - Configuration
- database.py - Firestore client
"""

import logging
import os

from fastapi import FastAPI, Depends, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from slowapi import Limiter, _rate_limit_exceeded_handler
from slowapi.util import get_remote_address
from slowapi.errors import RateLimitExceeded

from auth.middleware import AuthMiddleware
from auth.dependencies import get_current_user
from middleware.request_id import RequestIdMiddleware, get_request_id
from middleware.logging import configure_logging
from routes import (
    auth_router,
    trips_router,
    cars_router,
    locations_router,
    webhooks_router,
    stats_router,
    charging_router,
)
from routes.oauth import (
    audi_router,
    tesla_router,
    vwgroup_router,
    renault_router,
)

# Configure logging (JSON in production, plain text in dev)
configure_logging(json_format=os.getenv("ENV", "dev") == "prod")
logger = logging.getLogger(__name__)

# Create FastAPI app
app = FastAPI(title="mileage-tracker-api")

# Rate limiting
limiter = Limiter(key_func=get_remote_address)
app.state.limiter = limiter
app.add_exception_handler(RateLimitExceeded, _rate_limit_exceeded_handler)

# CORS middleware for frontend
# Specify allowed origins instead of "*" for security when credentials are enabled
ALLOWED_ORIGINS = [
    os.getenv("FRONTEND_URL", "https://mileage-tracker-frontend-xh7qepmwva-ez.a.run.app"),
    "http://localhost:3000",  # Local development
    "http://127.0.0.1:3000",  # Local development
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=ALLOWED_ORIGINS,
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
    allow_headers=["Authorization", "Content-Type", "X-User-Email"],
)

# Auth middleware
app.add_middleware(AuthMiddleware)

# Request ID middleware (for tracing)
app.add_middleware(RequestIdMiddleware)

# Include routers
app.include_router(auth_router)
app.include_router(trips_router)
app.include_router(cars_router)
app.include_router(locations_router)
app.include_router(webhooks_router)
app.include_router(stats_router)
app.include_router(charging_router)
app.include_router(audi_router)
app.include_router(tesla_router)
app.include_router(vwgroup_router)
app.include_router(renault_router)


@app.get("/")
def health():
    """Health check endpoint."""
    return {"status": "ok", "service": "mileage-tracker-api"}


# === Exception handlers with request_id ===


@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    """Handle all unhandled exceptions with request_id."""
    logger.exception(f"Unhandled exception: {exc}")
    return JSONResponse(
        status_code=500,
        content={
            "detail": "Internal server error",
            "request_id": get_request_id(),
        },
    )


@app.exception_handler(HTTPException)
async def http_exception_handler(request: Request, exc: HTTPException):
    """Add request_id to HTTP exceptions."""
    return JSONResponse(
        status_code=exc.status_code,
        content={
            "detail": exc.detail,
            "request_id": get_request_id(),
        },
    )


# === Legacy endpoints for backwards compatibility ===
# These endpoints are kept to ensure existing integrations continue to work.
# They delegate to the appropriate services.

from models.car import CarTestRequest
from services.car_service import car_service


@app.post("/car/test")
def test_car_credentials_legacy(request: CarTestRequest):
    """Test car credentials directly without saving (legacy endpoint)."""
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


@app.get("/cars/{car_id}/data")
def get_car_data_by_id_legacy(car_id: str, user_id: str = Depends(get_current_user)):
    """Get live car data for a specific car using its credentials (legacy endpoint)."""
    from fastapi import HTTPException
    from datetime import datetime, timezone
    from car_providers import AudiProvider, VWGroupProvider, RenaultProvider, TeslaProvider, VW_GROUP_BRANDS, VehicleState
    from database import get_db
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

    # Decrypt credentials (handles both encrypted and legacy plaintext)
    from services.car_service import _decrypt_credentials
    creds = _decrypt_credentials(creds_doc.to_dict())
    brand = creds.get("brand", car_data.get("brand", "")).lower()

    # Tesla and Audi use OAuth
    if brand == "tesla":
        if not creds.get("oauth_completed"):
            raise HTTPException(status_code=400, detail="Tesla authorization not complete.")
    elif brand == "audi":
        if not creds.get("oauth_completed"):
            raise HTTPException(status_code=400, detail="Audi authorization not complete.")
    elif brand in ("skoda", "seat", "cupra", "volkswagen"):
        if not creds.get("oauth_completed") and (not creds.get("username") or not creds.get("password")):
            raise HTTPException(status_code=400, detail=f"{brand.title()} authorization not complete.")
    elif brand == "renault":
        if not creds.get("oauth_completed") and (not creds.get("username") or not creds.get("password")):
            raise HTTPException(status_code=400, detail="Renault authorization not complete.")
    elif not creds.get("username") or not creds.get("password"):
        raise HTTPException(status_code=400, detail="Car has no API credentials configured")

    try:
        if brand == "tesla":
            provider = TeslaProvider(email=creds.get("username", x_user_email))
        elif brand == "renault":
            provider = RenaultProvider(
                username=creds["username"],
                password=creds["password"],
                locale=creds.get("locale", "nl_NL"),
                vin=creds.get("vin"),
            )
        elif brand == "audi":
            if creds.get("oauth_completed") and creds.get("access_token"):
                expires_at = creds.get("expires_at")
                if isinstance(expires_at, str):
                    try:
                        expires_at = datetime.fromisoformat(expires_at.replace("Z", "+00:00")).timestamp()
                    except:
                        expires_at = None

                provider = AudiProvider(
                    username=creds.get("username"),
                    password=creds.get("password"),
                    country=creds.get("country", "NL"),
                    vin=creds.get("vin"),
                    access_token=creds["access_token"],
                    id_token=creds.get("id_token"),
                    token_type=creds.get("token_type", "bearer"),
                    expires_at=expires_at,
                    refresh_token=creds.get("refresh_token"),
                )
            else:
                raise HTTPException(status_code=400, detail="Audi authorization not complete.")
        elif brand == "skoda" and creds.get("oauth_completed"):
            from car_providers.skoda import SkodaOAuthProvider
            provider = SkodaOAuthProvider(
                access_token=creds["access_token"],
                id_token=creds.get("id_token"),
            )
        elif brand in VW_GROUP_BRANDS:
            if creds.get("oauth_completed"):
                raise HTTPException(status_code=501, detail=f"{brand.title()} OAuth data fetch not yet implemented.")
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

        # Save refreshed tokens for Audi
        if brand == "audi" and hasattr(provider, 'get_tokens'):
            new_tokens = provider.get_tokens()
            if new_tokens and new_tokens.get("refresh_token"):
                try:
                    car_ref.collection("credentials").document("api").update({
                        "access_token": new_tokens["access_token"],
                        "id_token": new_tokens["id_token"],
                        "expires_at": new_tokens["expires_at"],
                        "refresh_token": new_tokens["refresh_token"],
                        "updated_at": datetime.utcnow().isoformat(),
                    })
                except Exception as e:
                    logger.warning(f"Failed to save refreshed tokens: {e}")

        provider.disconnect()

        # Convert VehicleState enum to string
        state_str = data.state.value if hasattr(data.state, 'value') else str(data.state)

        return {
            "car_id": car_id,
            "car_name": car_data.get("name", ""),
            "brand": brand,
            "vin": data.vin,
            "odometer_km": data.odometer_km,
            "latitude": data.latitude,
            "longitude": data.longitude,
            "state": state_str,
            "battery_level": data.battery_level,
            "range_km": data.range_km,
            "is_charging": data.is_charging,
            "is_plugged_in": data.is_plugged_in,
            "charging_power_kw": data.charging_power_kw,
            "charging_remaining_minutes": data.charging_remaining_minutes,
            "fetched_at": datetime.now(tz=timezone.utc).isoformat(),
        }
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to fetch car data: {str(e)}")


# === Backfill endpoints (admin only) ===

from database import get_db, load_custom_locations
from config import CONFIG
from utils.geo import haversine
from utils.routing import get_google_maps_route_distance, calculate_route_deviation

# Admin users allowed to run backfill operations
ADMIN_EMAILS = {"borismulder91@gmail.com"}


@app.post("/trips/backfill-latlon")
def backfill_latlon(user_id: str = Depends(get_current_user)):
    """Backfill lat/lon for existing trips based on known location names."""
    if user_id not in ADMIN_EMAILS:
        raise HTTPException(status_code=403, detail="Admin access required")
    db = get_db()
    load_custom_locations()

    updated = 0
    trips = db.collection("trips").stream()

    for doc in trips:
        d = doc.to_dict()
        updates = {}

        if not d.get("from_lat"):
            for label, loc in CONFIG["locations"].items():
                if label == d.get("from_address") and loc["lat"] != 0:
                    updates["from_lat"] = loc["lat"]
                    updates["from_lon"] = loc["lon"]
                    break

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
def backfill_google_maps(user_id: str = Depends(get_current_user)):
    """Backfill Google Maps route distance for existing trips."""
    if user_id not in ADMIN_EMAILS:
        raise HTTPException(status_code=403, detail="Admin access required")
    db = get_db()
    load_custom_locations()

    updated = 0
    skipped = 0
    errors = 0
    trips = list(db.collection("trips").stream())

    for doc in trips:
        d = doc.to_dict()

        if d.get("google_maps_km") is not None:
            skipped += 1
            continue

        from_lat = d.get("from_lat")
        from_lon = d.get("from_lon")
        to_lat = d.get("to_lat")
        to_lon = d.get("to_lon")

        if not all([from_lat, from_lon, to_lat, to_lon]):
            skipped += 1
            continue

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


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8080)
