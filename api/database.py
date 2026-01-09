"""
Database module for mileage-tracker API.
Handles Firestore client initialization and trip cache operations.
"""

import logging
from google.cloud import firestore

from config import CONFIG

logger = logging.getLogger(__name__)

# Firestore client (lazy init)
_db: firestore.Client | None = None
_locations_loaded = False


def get_db() -> firestore.Client:
    """Get or create Firestore client."""
    global _db
    if _db is None:
        _db = firestore.Client(project=CONFIG["project_id"])
    return _db


def load_custom_locations(user_id: str | None = None):
    """Load custom locations from Firestore into CONFIG (global, not per-user)."""
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


# === Trip Cache Operations ===
# Trip cache in Firestore to survive cold starts


def get_trip_cache(user_id: str) -> dict | None:
    """Get cached trip start from Firestore (per-user)."""
    try:
        db = get_db()
        doc = db.collection("users").document(user_id).collection("cache").document("trip_start").get()
        if doc.exists:
            return doc.to_dict()
    except Exception as e:
        logger.error(f"Failed to get trip cache: {e}")
    return None


def set_trip_cache(data: dict | None, user_id: str):
    """Set or clear trip start cache in Firestore (per-user)."""
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
    """Get all active trip caches across all users (for scheduler/safety net)."""
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
