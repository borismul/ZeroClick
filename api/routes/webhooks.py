"""
Webhook routes for trip tracking.
"""

from fastapi import APIRouter, HTTPException, Header

from models.location import WebhookLocation
from models.trip import TripEvent
from services.webhook_service import webhook_service

router = APIRouter(prefix="/webhook", tags=["webhooks"])


@router.post("/ping")
def webhook_ping(
    loc: WebhookLocation,
    user: str | None = None,
    car_id: str | None = None,
    device_id: str | None = None,
):
    """iPhone Shortcuts - GPS ping. Collects coordinates during trip and checks car status."""
    if not user:
        raise HTTPException(status_code=401, detail="User parameter required")
    return webhook_service.handle_ping(user, loc.lat, loc.lng, car_id, device_id)


@router.post("/start")
def webhook_start(
    loc: WebhookLocation,
    user: str | None = None,
    car_id: str | None = None,
    device_id: str | None = None,
):
    """iPhone Shortcuts - Bluetooth/CarPlay connected. Just records GPS."""
    if not user:
        raise HTTPException(status_code=401, detail="User parameter required")
    return webhook_service.handle_start(user, loc.lat, loc.lng, car_id, device_id)


@router.post("/end")
def webhook_end(loc: WebhookLocation, user: str | None = None):
    """iPhone Shortcuts - Bluetooth/CarPlay disconnected. Tries to finalize trip immediately."""
    if not user:
        raise HTTPException(status_code=401, detail="User parameter required")
    return webhook_service.handle_end(user, loc.lat, loc.lng)


@router.post("/finalize")
def webhook_finalize(user: str | None = None, x_user_email: str | None = Header(None)):
    """Force finalize a pending trip by fetching current odometer."""
    user_id = user or x_user_email
    if not user_id:
        raise HTTPException(status_code=401, detail="User parameter required")
    return webhook_service.handle_finalize(user_id)


@router.post("/cancel")
def webhook_cancel(user: str | None = None, x_user_email: str | None = Header(None)):
    """Cancel the current trip without saving."""
    user_id = user or x_user_email
    if not user_id:
        raise HTTPException(status_code=401, detail="User required")
    return webhook_service.handle_cancel(user_id)


@router.get("/status")
def webhook_status(user: str | None = None, x_user_email: str | None = Header(None)):
    """Check current trip status."""
    user_id = user or x_user_email
    if not user_id:
        raise HTTPException(status_code=401, detail="User required")
    return webhook_service.get_status(user_id)


# Legacy webhook endpoint
@router.post("")
def handle_webhook(event: TripEvent):
    """iPhone Shortcuts webhook for simple trip start/end events (legacy)."""
    # Note: This legacy endpoint uses an in-memory cache and doesn't integrate
    # with the modern webhook service. It's kept for backwards compatibility.
    from database import get_db
    from services.trip_service import trip_service
    import logging

    logger = logging.getLogger(__name__)
    logger.info(f"Legacy webhook: {event.event} at {event.lat}, {event.lon}")

    # Legacy trip cache (in-memory, doesn't survive restarts)
    # This is intentionally kept simple for backwards compatibility
    trip_cache = {}

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

        # Process using the trip service (simplified legacy path)
        from services.location_service import location_service
        from config import CONFIG

        start_loc = location_service.reverse_geocode(start["lat"], start["lon"])
        end_loc = location_service.reverse_geocode(event.lat, event.lon)
        distance = location_service.calculate_distance(start["lat"], start["lon"], event.lat, event.lon)

        if distance["distance_km"] < CONFIG["min_trip_km"]:
            return {"ignored": True}

        # For legacy endpoint, just return success without full processing
        return {"status": "trip_logged", "distance_km": distance["distance_km"]}

    raise HTTPException(status_code=400, detail="Invalid event")
