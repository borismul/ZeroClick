"""
Location service - geocoding and distance calculations.
"""

import logging
import requests

from config import CONFIG
from database import get_db, load_custom_locations
from utils.geo import haversine

logger = logging.getLogger(__name__)


class LocationService:
    """Service for location-related operations."""

    def is_skip_location(self, lat: float, lon: float) -> bool:
        """Check if location is a skip location (e.g., daycare)."""
        skip = CONFIG["skip_location"]
        if skip["lat"] == 0:
            return False
        distance = haversine(lat, lon, skip["lat"], skip["lon"])
        return distance <= skip["radius"]

    def reverse_geocode(self, lat: float, lon: float, user_id: str | None = None) -> dict:
        """
        Convert coordinates to address.

        First checks known locations, then falls back to Google Maps API.

        Args:
            lat, lon: Coordinates to geocode
            user_id: Optional user ID for custom locations

        Returns:
            Dict with address, label, is_business, lat, lon
        """
        # Load custom locations from Firestore
        load_custom_locations(user_id)

        # Check known locations first
        for label, loc in CONFIG["locations"].items():
            if loc["lat"] == 0:
                continue
            if haversine(lat, lon, loc["lat"], loc["lon"]) <= loc["radius"]:
                return {
                    "address": label,
                    "label": label,
                    "is_business": loc["is_business"],
                    "lat": lat,
                    "lon": lon,
                }

        # Fall back to Google Maps API
        api_key = CONFIG["maps_api_key"]
        if not api_key:
            return {
                "address": f"{lat:.4f}, {lon:.4f}",
                "label": None,
                "is_business": None,
                "lat": lat,
                "lon": lon,
            }

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

        return {
            "address": f"{lat:.4f}, {lon:.4f}",
            "label": None,
            "is_business": None,
            "lat": lat,
            "lon": lon,
        }

    def calculate_distance(self, lat1: float, lon1: float, lat2: float, lon2: float) -> dict:
        """
        Calculate driving distance between two points.

        Uses Google Maps Directions API if available, falls back to haversine.

        Args:
            lat1, lon1: Start coordinates
            lat2, lon2: End coordinates

        Returns:
            Dict with distance_km
        """
        api_key = CONFIG["maps_api_key"]
        if api_key:
            try:
                url = f"https://maps.googleapis.com/maps/api/directions/json?origin={lat1},{lon1}&destination={lat2},{lon2}&mode=driving&key={api_key}"
                data = requests.get(url, timeout=10).json()
                if data["status"] == "OK":
                    return {"distance_km": data["routes"][0]["legs"][0]["distance"]["value"] / 1000}
            except Exception as e:
                logger.error(f"Directions error: {e}")

        # Fallback: haversine with 1.3x multiplier for road distance
        return {"distance_km": haversine(lat1, lon1, lat2, lon2) * 1.3 / 1000}

    def get_locations(self) -> list[dict]:
        """Get all custom locations."""
        db = get_db()
        docs = db.collection("locations").stream()
        return [{"name": doc.id, **doc.to_dict()} for doc in docs]

    def add_location(self, name: str, lat: float, lng: float) -> dict:
        """
        Add a custom location and update existing trips.

        Args:
            name: Location name
            lat, lng: Coordinates

        Returns:
            Dict with status, name, trips_updated
        """
        from datetime import datetime

        db = get_db()
        db.collection("locations").document(name).set({
            "lat": lat,
            "lng": lng,
            "created_at": datetime.utcnow().isoformat(),
        })

        # Also add to runtime config for immediate use
        CONFIG["locations"][name] = {
            "lat": lat,
            "lon": lng,
            "radius": 150,
            "is_business": True,
        }

        # Update existing trips within 150m radius
        updated = 0
        trips = db.collection("trips").stream()
        for doc in trips:
            d = doc.to_dict()
            updates = {}
            # Check from location
            if d.get("from_lat") and d.get("from_lon"):
                if haversine(lat, lng, d["from_lat"], d["from_lon"]) <= 150:
                    updates["from_address"] = name
            # Check to location
            if d.get("to_lat") and d.get("to_lon"):
                if haversine(lat, lng, d["to_lat"], d["to_lon"]) <= 150:
                    updates["to_address"] = name
            if updates:
                doc.reference.update(updates)
                updated += 1

        return {"status": "added", "name": name, "trips_updated": updated}

    def delete_location(self, name: str) -> dict:
        """Delete a custom location."""
        db = get_db()
        db.collection("locations").document(name).delete()
        CONFIG["locations"].pop(name, None)
        return {"status": "deleted"}


# Singleton instance
location_service = LocationService()
