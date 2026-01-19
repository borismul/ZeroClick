"""
Trip service - trip CRUD and finalization.
"""

import logging
from datetime import datetime
from collections.abc import Sequence

from google.cloud import firestore

from config import CONFIG
from database import get_db, load_custom_locations
from models.trip import Trip, GpsPoint
from utils.ids import generate_id
from utils.routing import get_google_maps_route_distance, calculate_route_deviation
from .location_service import location_service
from .car_service import car_service

logger = logging.getLogger(__name__)


class TripService:
    """Service for trip-related operations."""

    def get_trips(
        self,
        user_id: str,
        year: int | None = None,
        month: int | None = None,
        car_id: str | None = None,
        cursor: str | None = None,
        limit: int = 50,
    ) -> tuple[Sequence[Trip], str | None]:
        """
        Get trips with cursor-based pagination.

        Args:
            user_id: User ID
            year: Optional year filter
            month: Optional month filter (requires year)
            car_id: Optional car ID filter (uses Firestore query, not client-side)
            cursor: Document ID to start after (for pagination)
            limit: Number of trips to return

        Returns:
            Tuple of (trips, next_cursor) where next_cursor is None if no more results
        """
        db = get_db()

        # Build query with user_id filter
        query = db.collection("trips").where(
            filter=firestore.FieldFilter("user_id", "==", user_id)
        )

        # Add car_id filter directly to query (eliminates client-side filtering)
        # Note: Requires composite index (user_id, car_id, __name__)
        if car_id:
            query = query.where(
                filter=firestore.FieldFilter("car_id", "==", car_id)
            )

        # Add date filters
        if year and month:
            start = f"{month:02d}-{year}"
            end = f"{month:02d}-{year}"
            query = query.where(filter=firestore.FieldFilter("date", ">=", f"01-{start}"))
            query = query.where(filter=firestore.FieldFilter("date", "<=", f"31-{end}"))

        # Sort by document ID descending - IDs are YYYYMMDD-HHMM-XXX format
        query = query.order_by("__name__", direction=firestore.Query.DESCENDING)

        # Apply cursor if provided (cursor is document ID)
        if cursor:
            cursor_doc = db.collection("trips").document(cursor).get()
            if cursor_doc.exists:
                query = query.start_after(cursor_doc)

        # Fetch limit + 1 to detect if there are more results
        docs = list(query.limit(limit + 1).stream())

        # Determine if there are more results
        has_more = len(docs) > limit
        if has_more:
            docs = docs[:limit]

        trips = [self._doc_to_trip(doc) for doc in docs]
        next_cursor = docs[-1].id if has_more and docs else None

        return trips, next_cursor

    def get_trips_legacy(
        self,
        user_id: str,
        year: int | None = None,
        month: int | None = None,
        car_id: str | None = None,
        page: int = 1,
        limit: int = 50,
    ) -> Sequence[Trip]:
        """
        Legacy offset-based pagination (for backwards compatibility).
        NOTE: Inefficient - use get_trips() with cursor instead.
        """
        trips, _ = self.get_trips(user_id, year, month, car_id, cursor=None, limit=page * limit)
        offset = (page - 1) * limit
        return trips[offset:offset + limit]

    def get_trip(self, trip_id: str) -> Trip | None:
        """Get single trip by ID."""
        db = get_db()
        doc = db.collection("trips").document(trip_id).get()
        if not doc.exists:
            return None
        return self._doc_to_trip(doc)

    def create_manual_trip(
        self,
        user_id: str,
        date: str,
        from_address: str,
        to_address: str,
        distance_km: float,
        trip_type: str = "B",
        start_time: str = "09:00",
        end_time: str = "10:00",
        car_id: str | None = None,
    ) -> Trip:
        """Create a manual trip."""
        db = get_db()
        trip_id = generate_id()
        prev_odo = self.get_last_odometer(user_id)

        # Calculate business/private km based on type
        if trip_type == "B":
            business_km = distance_km
            private_km = 0
        elif trip_type == "P":
            business_km = 0
            private_km = distance_km
        else:  # Mixed
            business_km = distance_km / 2
            private_km = distance_km / 2

        # Lookup lat/lon from known locations
        load_custom_locations(user_id)
        from_lat, from_lon, to_lat, to_lon = None, None, None, None
        for label, loc in CONFIG["locations"].items():
            if label == from_address and loc["lat"] != 0:
                from_lat, from_lon = loc["lat"], loc["lon"]
            if label == to_address and loc["lat"] != 0:
                to_lat, to_lon = loc["lat"], loc["lon"]

        # Use provided car_id, fall back to default car
        effective_car_id = car_id or car_service.get_default_car_id(user_id)

        trip_data = {
            "id": trip_id,
            "date": date,
            "start_time": start_time,
            "end_time": end_time,
            "from_address": from_address,
            "to_address": to_address,
            "from_lat": from_lat,
            "from_lon": from_lon,
            "to_lat": to_lat,
            "to_lon": to_lon,
            "distance_km": distance_km,
            "trip_type": trip_type,
            "business_km": round(business_km, 1),
            "private_km": round(private_km, 1),
            "start_odo": round(prev_odo, 1),
            "end_odo": round(prev_odo + distance_km, 1),
            "notes": "",
            "created_at": datetime.utcnow().isoformat(),
            "car_id": effective_car_id,
            "user_id": user_id,
        }

        db.collection("trips").document(trip_id).set(trip_data)
        return self._doc_to_trip(db.collection("trips").document(trip_id).get())

    def create_full_trip(
        self,
        user_id: str,
        date: str,
        start_time: str,
        end_time: str,
        from_lat: float,
        from_lon: float,
        to_lat: float,
        to_lon: float,
        distance_km: float,
        start_odo: float,
        end_odo: float,
        trip_type: str = "P",
        car_id: str | None = None,
        gps_trail: list = None,
    ) -> Trip:
        """Create a trip with full details including GPS trail (for recovery)."""
        db = get_db()
        trip_id = generate_id()

        # Geocode start and end
        start_loc = location_service.reverse_geocode(from_lat, from_lon, user_id)
        end_loc = location_service.reverse_geocode(to_lat, to_lon, user_id)

        # Get route distance for comparison
        google_maps_km = get_google_maps_route_distance(from_lat, from_lon, to_lat, to_lon)
        route_info = calculate_route_deviation(distance_km, google_maps_km)

        trip_data = {
            "id": trip_id,
            "date": date,
            "start_time": start_time,
            "end_time": end_time,
            "from_address": start_loc["label"] or start_loc["address"],
            "to_address": end_loc["label"] or end_loc["address"],
            "from_lat": from_lat,
            "from_lon": from_lon,
            "to_lat": to_lat,
            "to_lon": to_lon,
            "distance_km": round(distance_km, 1),
            "trip_type": trip_type,
            "business_km": 0 if trip_type == "P" else round(distance_km, 1),
            "private_km": round(distance_km, 1) if trip_type == "P" else 0,
            "start_odo": round(start_odo, 1),
            "end_odo": round(end_odo, 1),
            "notes": "",
            "created_at": datetime.utcnow().isoformat(),
            "car_id": car_id or car_service.get_default_car_id(user_id),
            "user_id": user_id,
            "gps_trail": [{"lat": p["lat"], "lng": p["lng"], "timestamp": p.get("timestamp")} for p in (gps_trail or [])],
            "google_maps_km": google_maps_km,
            "route_deviation_percent": route_info.get("deviation_percent"),
            "route_flag": route_info.get("flag"),
        }

        db.collection("trips").document(trip_id).set(trip_data)
        return self._doc_to_trip(db.collection("trips").document(trip_id).get())

    def update_trip(self, trip_id: str, updates: dict) -> Trip | None:
        """Update trip fields."""
        db = get_db()
        ref = db.collection("trips").document(trip_id)
        doc = ref.get()

        if not doc.exists:
            return None

        data = doc.to_dict()
        db_updates = {}

        # Simple field updates
        for field in ["date", "start_time", "end_time", "from_address", "to_address",
                      "distance_km", "business_km", "private_km", "notes", "car_id"]:
            if field in updates and updates[field] is not None:
                db_updates[field] = updates[field]

        # Handle trip_type with business/private km recalc
        if updates.get("trip_type"):
            db_updates["trip_type"] = updates["trip_type"]
            distance = updates.get("distance_km") if updates.get("distance_km") is not None else data["distance_km"]
            if updates["trip_type"] == "B":
                db_updates["business_km"] = distance
                db_updates["private_km"] = 0
            elif updates["trip_type"] == "P":
                db_updates["business_km"] = 0
                db_updates["private_km"] = distance

        # route_flag can be set to None to clear it
        if "route_flag" in updates:
            db_updates["route_flag"] = updates["route_flag"]

        if db_updates:
            ref.update(db_updates)

        return self._doc_to_trip(ref.get())

    def delete_trip(self, trip_id: str) -> bool:
        """Delete a trip."""
        db = get_db()
        ref = db.collection("trips").document(trip_id)
        if not ref.get().exists:
            return False
        ref.delete()
        return True

    def get_last_odometer(self, user_id: str) -> float:
        """Get the last odometer reading for a user."""
        db = get_db()
        query = db.collection("trips").where(
            filter=firestore.FieldFilter("user_id", "==", user_id)
        ).order_by("created_at", direction=firestore.Query.DESCENDING)
        docs = query.limit(1).stream()
        for doc in docs:
            return doc.to_dict().get("end_odo", CONFIG["start_odometer"])
        return CONFIG["start_odometer"]

    def classify_trip(
        self,
        timestamp: str,
        start_loc: dict,
        end_loc: dict,
        distance: float,
    ) -> dict:
        """
        Classification logic:
        - Thuis <-> Kantoor (commute) = Business
        - Kantoor -> anywhere = Business
        - Thuis -> anywhere on weekday = Business (assume client visit)
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

    def finalize_trip_from_audi(
        self,
        start_gps: dict,
        end_gps: dict,
        start_odo: float,
        end_odo: float,
        start_time: str,
        user_id: str,
        gps_trail: list = None,
        car_id: str | None = None,
        distance_source: str = "odometer",
    ) -> dict:
        """
        Finalize trip using start GPS, end GPS, and odometer.

        Args:
            distance_source: "odometer" (from car API), "osrm" (from OSRM routing), or "gps" (haversine fallback)
        """
        if gps_trail is None:
            gps_trail = []

        # Geocode start and end
        start_loc = location_service.reverse_geocode(start_gps["lat"], start_gps["lng"], user_id)
        end_loc = location_service.reverse_geocode(end_gps["lat"], end_gps["lng"], user_id)

        # Distance from odometer (ground truth) or GPS fallback
        distance_km = end_odo - start_odo

        # Get route distance for comparison
        google_maps_km = get_google_maps_route_distance(
            start_gps["lat"], start_gps["lng"],
            end_gps["lat"], end_gps["lng"]
        )
        route_info = calculate_route_deviation(distance_km, google_maps_km)

        # Parse timestamps
        start_dt = datetime.fromisoformat(start_time.replace("Z", "+00:00"))
        end_dt = datetime.fromisoformat(end_gps["timestamp"].replace("Z", "+00:00"))

        # Classify trip
        classification = self.classify_trip(start_time, start_loc, end_loc, distance_km)

        # Use provided car_id, fall back to default car, or "unknown"
        effective_car_id = car_id or car_service.get_default_car_id(user_id) or "unknown"

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
            "gps_trail": gps_trail,
            "google_maps_km": route_info["google_maps_km"],
            "route_deviation_percent": route_info["deviation_percent"],
            "route_flag": route_info["flag"],
            "distance_source": distance_source,
        }

        db = get_db()
        db.collection("trips").document(trip_id).set(trip_data)
        logger.info(f"Trip finalized: {trip_id}, {distance_km} km (source: {distance_source}), {start_loc['label']} -> {end_loc['label']}")

        # Save end GPS and odometer as last_parked for next trip start
        if effective_car_id and effective_car_id != "unknown":
            car_service.save_last_parked_gps(user_id, effective_car_id, end_gps["lat"], end_gps["lng"], end_gps["timestamp"], end_odo)

        # Update denormalized car stats
        car_service.update_car_stats(user_id, effective_car_id, distance_km)

        return trip_data

    def finalize_trip_from_gps(
        self,
        start_gps: dict,
        end_gps: dict,
        gps_trail: list,
        gps_distance_km: float,
        start_time: str,
        user_id: str,
        car_id: str | None = None,
    ) -> dict:
        """
        Finalize trip using GPS data only (when car API is unavailable).
        Distance is calculated from GPS trail using OSRM routing or haversine.
        """
        # Geocode start and end
        start_loc = location_service.reverse_geocode(start_gps["lat"], start_gps["lng"], user_id)
        end_loc = location_service.reverse_geocode(end_gps["lat"], end_gps["lng"], user_id)

        # Get route distance for comparison
        google_maps_km = get_google_maps_route_distance(
            start_gps["lat"], start_gps["lng"],
            end_gps["lat"], end_gps["lng"]
        )
        route_info = calculate_route_deviation(gps_distance_km, google_maps_km)

        # Parse timestamps
        start_dt = datetime.fromisoformat(start_time.replace("Z", "+00:00"))
        end_dt = datetime.fromisoformat(end_gps["timestamp"].replace("Z", "+00:00"))

        # Classify trip
        classification = self.classify_trip(start_time, start_loc, end_loc, gps_distance_km)

        # Use provided car_id, fall back to default car, or "unknown"
        effective_car_id = car_id or car_service.get_default_car_id(user_id) or "unknown"

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
            "distance_km": round(gps_distance_km, 1),
            "trip_type": classification["type"],
            "business_km": round(classification["business_km"], 1),
            "private_km": round(classification["private_km"], 1),
            "start_odo": None,  # No odometer in GPS-only mode
            "end_odo": None,
            "notes": "GPS-only mode (car API unavailable)",
            "created_at": datetime.utcnow().isoformat(),
            "car_id": effective_car_id,
            "gps_trail": gps_trail,
            "google_maps_km": route_info["google_maps_km"],
            "route_deviation_percent": route_info["deviation_percent"],
            "route_flag": route_info["flag"],
            "distance_source": "gps_only",
        }

        db = get_db()
        db.collection("trips").document(trip_id).set(trip_data)
        logger.info(f"Trip finalized (GPS-only): {trip_id}, {gps_distance_km:.1f} km, {start_loc['label']} -> {end_loc['label']}")

        # Save end GPS as last_parked for next trip start
        if effective_car_id and effective_car_id != "unknown":
            car_service.save_last_parked_gps(user_id, effective_car_id, end_gps["lat"], end_gps["lng"], end_gps["timestamp"])

        # Update denormalized car stats
        car_service.update_car_stats(user_id, effective_car_id, gps_distance_km)

        return trip_data

    def _doc_to_trip(self, doc) -> Trip:
        """Convert Firestore document to Trip model."""
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
            distance_km=d.get("distance_km") or 0,
            trip_type=d.get("trip_type") or "B",
            business_km=d.get("business_km") or 0,
            private_km=d.get("private_km") or 0,
            start_odo=d.get("start_odo") or 0,
            end_odo=d.get("end_odo") or 0,
            notes=d.get("notes", ""),
            created_at=d.get("created_at", ""),
            car_id=d.get("car_id"),
            gps_trail=gps_trail,
            google_maps_km=d.get("google_maps_km"),
            route_deviation_percent=d.get("route_deviation_percent"),
            route_flag=d.get("route_flag"),
            distance_source=d.get("distance_source"),
        )


# Singleton instance
trip_service = TripService()
