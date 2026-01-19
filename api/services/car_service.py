"""
Car service - car management and API credential operations.
"""

import logging
from datetime import datetime

from google.cloud import firestore

from config import CONFIG
from database import get_db
from models.car import Car

logger = logging.getLogger(__name__)


class CarService:
    """Service for car-related operations."""

    def get_cars(self, user_id: str) -> list[Car]:
        """Get all cars for a user with stats (denormalized in car document)."""
        db = get_db()
        cars_ref = db.collection("users").document(user_id).collection("cars")
        cars = []

        for doc in cars_ref.order_by("created_at").stream():
            data = doc.to_dict()
            # Read stats directly from car document (denormalized)
            # No longer queries trips collection (was N+1 query)
            total_trips = data.get("total_trips", 0)
            total_km = data.get("total_km", 0.0)
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

    def get_car(self, user_id: str, car_id: str) -> Car | None:
        """Get a single car by ID."""
        db = get_db()
        car_ref = db.collection("users").document(user_id).collection("cars").document(car_id)
        doc = car_ref.get()

        if not doc.exists:
            return None

        data = doc.to_dict()
        # Read stats directly from car document (denormalized)
        total_trips = data.get("total_trips", 0)
        total_km = data.get("total_km", 0.0)

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

    def create_car(self, user_id: str, name: str, brand: str = "other",
                   color: str = "#3B82F6", icon: str = "car",
                   start_odometer: float = 0) -> Car:
        """Create a new car."""
        db = get_db()
        cars_ref = db.collection("users").document(user_id).collection("cars")

        # Check if this is the first car (make it default)
        existing = list(cars_ref.limit(1).stream())
        is_first = len(existing) == 0

        # Create car document
        car_id = db.collection("_").document().id  # Generate unique ID
        now = datetime.utcnow().isoformat()

        car_data = {
            "name": name,
            "brand": brand,
            "color": color,
            "icon": icon,
            "is_default": is_first,  # First car is default
            "start_odometer": start_odometer,
            "created_at": now,
            "last_used": None,
        }

        cars_ref.document(car_id).set(car_data)

        return Car(
            id=car_id,
            name=name,
            brand=brand,
            color=color,
            icon=icon,
            is_default=is_first,
            start_odometer=start_odometer,
            created_at=now,
            total_trips=0,
            total_km=0,
        )

    def update_car(self, user_id: str, car_id: str, updates: dict) -> dict:
        """Update a car."""
        db = get_db()
        cars_ref = db.collection("users").document(user_id).collection("cars")
        car_ref = cars_ref.document(car_id)

        if not car_ref.get().exists:
            return None

        db_updates = {}
        for field in ["name", "brand", "color", "icon", "carplay_device_id", "start_odometer"]:
            if field in updates and updates[field] is not None:
                db_updates[field] = updates[field]

        # Handle is_default - unset others if setting to true
        if updates.get("is_default") is True:
            # Unset all other cars as default
            for other_doc in cars_ref.where("is_default", "==", True).stream():
                if other_doc.id != car_id:
                    cars_ref.document(other_doc.id).update({"is_default": False})
            db_updates["is_default"] = True
        elif updates.get("is_default") is False:
            db_updates["is_default"] = False

        if db_updates:
            car_ref.update(db_updates)

        return {"status": "updated", "car_id": car_id}

    def delete_car(self, user_id: str, car_id: str) -> dict | None:
        """Delete a car (trips remain but car_id becomes null)."""
        db = get_db()
        cars_ref = db.collection("users").document(user_id).collection("cars")
        car_ref = cars_ref.document(car_id)
        doc = car_ref.get()

        if not doc.exists:
            return None

        # Check if this is the last car
        all_cars = list(cars_ref.stream())
        if len(all_cars) <= 1:
            return {"error": "Cannot delete last car"}

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
        for trip in trips_col.where(
            filter=firestore.FieldFilter("user_id", "==", user_id)
        ).where(
            filter=firestore.FieldFilter("car_id", "==", car_id)
        ).stream():
            trips_col.document(trip.id).update({"car_id": None})

        return {"status": "deleted"}

    def get_car_stats(self, user_id: str, car_id: str) -> tuple[int, float]:
        """
        Get trip count and total km for a car by querying trips collection.

        NOTE: This is now only used for migration/backfill purposes.
        Normal reads use denormalized stats from car document.
        TODO: Run migration to backfill total_trips/total_km for existing cars
        """
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

    def update_car_stats(self, user_id: str, car_id: str, km_delta: float, trip_delta: int = 1) -> None:
        """
        Increment car stats after trip completion. Uses atomic increment.

        Args:
            user_id: User ID
            car_id: Car ID
            km_delta: Distance to add (can be negative for corrections)
            trip_delta: Number of trips to add (default 1)
        """
        if not car_id or car_id == "unknown":
            return

        db = get_db()
        car_ref = db.collection("users").document(user_id).collection("cars").document(car_id)

        try:
            car_ref.update({
                "total_trips": firestore.Increment(trip_delta),
                "total_km": firestore.Increment(km_delta),
            })
            logger.info(f"Updated car stats for {car_id}: +{trip_delta} trips, +{km_delta:.1f} km")
        except Exception as e:
            logger.error(f"Failed to update car stats for {car_id}: {e}")

    def get_default_car_id(self, user_id: str) -> str | None:
        """Get the default car ID for a user."""
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

    def get_car_id_by_device(self, user_id: str, device_id: str) -> str | None:
        """Get car ID by matching carplay_device_id."""
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

    def get_car_start_odometer(self, user_id: str, car_id: str | None) -> float:
        """Get start_odometer for a specific car, falls back to CONFIG."""
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

    def update_car_last_used(self, user_id: str, car_id: str):
        """Update the last_used timestamp for a car."""
        if not car_id:
            return
        db = get_db()
        car_ref = db.collection("users").document(user_id).collection("cars").document(car_id)
        if car_ref.get().exists:
            car_ref.update({"last_used": datetime.utcnow().isoformat()})

    # === Credential Management ===

    def get_cars_with_credentials(self, user_id: str) -> list[dict]:
        """Get all cars that have API credentials configured."""
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
                # Support both username/password and OAuth-based auth
                has_password_auth = creds.get("username") and creds.get("password")
                has_oauth_auth = creds.get("oauth_completed") and creds.get("access_token")
                if has_password_auth or has_oauth_auth:
                    cars_with_creds.append({
                        "car_id": car_id,
                        "user_id": user_id,
                        "name": car_data.get("name", car_id),
                        "brand": creds.get("brand", car_data.get("brand", "")).lower(),
                        "credentials": creds,
                    })

        return cars_with_creds

    def save_car_credentials(self, user_id: str, car_id: str, creds: dict) -> dict:
        """Save API credentials for a specific car."""
        db = get_db()
        car_ref = db.collection("users").document(user_id).collection("cars").document(car_id)

        if not car_ref.get().exists:
            return None

        # Store credentials in a subcollection for security
        creds_ref = car_ref.collection("credentials").document("api")
        creds_ref.set({
            "brand": creds.get("brand", "audi"),
            "username": creds.get("username", ""),
            "password": creds.get("password", ""),
            "country": creds.get("country", "NL"),
            "locale": creds.get("locale", "nl_NL"),
            "spin": creds.get("spin", ""),
            "start_odometer": creds.get("start_odometer", 0),
            "updated_at": datetime.utcnow().isoformat(),
        })

        # Update car brand to match credentials
        car_ref.update({"brand": creds.get("brand", "audi")})

        return {"status": "saved"}

    def get_car_credentials_status(self, user_id: str, car_id: str) -> dict | None:
        """Get credentials status for a specific car (not the actual password)."""
        db = get_db()
        car_ref = db.collection("users").document(user_id).collection("cars").document(car_id)

        if not car_ref.get().exists:
            return None

        creds_doc = car_ref.collection("credentials").document("api").get()
        if not creds_doc.exists:
            return {"error": "No credentials configured"}

        creds = creds_doc.to_dict()
        # Return credential info but NOT the password
        return {
            "brand": creds.get("brand"),
            "username": creds.get("username"),
            "has_password": bool(creds.get("password")),
            "oauth_completed": creds.get("oauth_completed", False),
            "country": creds.get("country"),
            "updated_at": creds.get("updated_at"),
        }

    def delete_car_credentials(self, user_id: str, car_id: str) -> dict | None:
        """Delete/logout credentials for a specific car."""
        db = get_db()
        car_ref = db.collection("users").document(user_id).collection("cars").document(car_id)

        if not car_ref.get().exists:
            return None

        # Delete credentials
        car_ref.collection("credentials").document("api").delete()
        # Also delete oauth_state if exists
        car_ref.collection("credentials").document("oauth_state").delete()

        return {"status": "deleted"}

    def save_last_parked_gps(self, user_id: str, car_id: str, lat: float, lng: float, timestamp: str, odometer: float | None = None):
        """Save the last parked GPS position and odometer for a car."""
        try:
            db = get_db()
            update_data = {
                "last_parked_lat": lat,
                "last_parked_lng": lng,
                "last_parked_at": timestamp,
            }
            if odometer is not None:
                update_data["last_parked_odo"] = odometer
            db.collection("users").document(user_id).collection("cars").document(car_id).update(update_data)
            logger.info(f"Saved last parked GPS for {car_id}: {lat}, {lng}, odo={odometer}")
        except Exception as e:
            logger.error(f"Failed to save last parked GPS: {e}")

    def get_last_parked_gps(self, user_id: str, car_id: str) -> dict | None:
        """Get the last parked GPS position and odometer for a car."""
        try:
            db = get_db()
            car_doc = db.collection("users").document(user_id).collection("cars").document(car_id).get()
            if car_doc.exists:
                data = car_doc.to_dict()
                if data.get("last_parked_lat") and data.get("last_parked_lng"):
                    return {
                        "lat": data["last_parked_lat"],
                        "lng": data["last_parked_lng"],
                        "timestamp": data.get("last_parked_at", ""),
                        "odometer": data.get("last_parked_odo"),
                    }
        except Exception as e:
            logger.error(f"Failed to get last parked GPS: {e}")
        return None

    def check_car_driving_status(self, car_info: dict) -> dict | None:
        """Check if a specific car is driving. Returns car data if driving, None if parked/error."""
        from car_providers import AudiProvider, VWGroupProvider, RenaultProvider, VW_GROUP_BRANDS, VehicleState

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
            elif brand == "audi":
                # Audi uses OAuth only
                if not creds.get("oauth_completed") or not creds.get("access_token"):
                    logger.warning(f"Audi car {car_info['car_id']} has no OAuth tokens")
                    return None

                expires_at = creds.get("expires_at")
                if isinstance(expires_at, str):
                    try:
                        expires_at = datetime.fromisoformat(expires_at.replace("Z", "+00:00")).timestamp()
                    except:
                        expires_at = None

                provider = AudiProvider(
                    country=creds.get("country", "NL"),
                    vin=creds.get("vin"),
                    access_token=creds["access_token"],
                    id_token=creds.get("id_token"),
                    token_type=creds.get("token_type", "bearer"),
                    expires_at=expires_at,
                    refresh_token=creds.get("refresh_token"),
                )
            elif brand in VW_GROUP_BRANDS:
                # Use VWGroupProvider for other VW Group brands
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

            # Save refreshed tokens back to Firestore (for Audi OAuth)
            if brand == "audi" and hasattr(provider, 'get_tokens'):
                new_tokens = provider.get_tokens()
                if new_tokens and new_tokens.get("refresh_token"):
                    try:
                        user_id = car_info.get("user_id")
                        car_id = car_info["car_id"]
                        if user_id:
                            db = get_db()
                            creds_ref = db.collection("users").document(user_id).collection("cars").document(car_id).collection("credentials").document("api")
                            creds_ref.update({
                                "access_token": new_tokens["access_token"],
                                "id_token": new_tokens["id_token"],
                                "expires_at": new_tokens["expires_at"],
                                "refresh_token": new_tokens["refresh_token"],
                                "updated_at": datetime.utcnow().isoformat(),
                            })
                            logger.info(f"Saved refreshed Audi tokens for car {car_id}")
                    except Exception as e:
                        logger.warning(f"Failed to save refreshed tokens: {e}")

            provider.disconnect()

            # Handle state from CarData
            if data.state == VehicleState.PARKED:
                is_parked = True
                vehicle_state = "parked"
            elif data.state == VehicleState.DRIVING:
                is_parked = False
                vehicle_state = "driving"
            elif data.state == VehicleState.CHARGING:
                is_parked = True
                vehicle_state = "charging"
            else:
                # State unknown - return None to indicate unreliable data
                # This prevents counters from being reset based on bad API data
                raw = data.raw_data or {}
                vehicle_state = raw.get("state", {}).get("val", "unknown")
                is_parked = None  # Unknown state - don't assume parked or driving

            # Get odometer
            odometer = data.odometer_km

            # Get GPS position
            lat = data.latitude
            lng = data.longitude
            if lat is None or lng is None:
                raw = data.raw_data or {}
                position = raw.get("position", {})
                lat = lat or position.get("latitude", {}).get("val")
                lng = lng or position.get("longitude", {}).get("val")

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
            import traceback
            logger.error(traceback.format_exc())
            return None

    def find_driving_car(self, user_id: str) -> tuple[dict | None, str]:
        """
        Find which car (if any) is currently driving.

        Returns:
            tuple: (car_status, reason) where reason is one of:
                - "driving": car is driving (car_status contains car info)
                - "parked": checked cars but none driving
                - "no_cars": no cars configured with credentials
                - "api_error": all API checks failed
        """
        cars = self.get_cars_with_credentials(user_id)
        logger.info(f"Checking {len(cars)} cars for driving status")
        timestamp = datetime.utcnow().isoformat() + "Z"

        if not cars:
            logger.info("No cars with credentials configured")
            return None, "no_cars"

        api_errors = 0
        for car_info in cars:
            status = self.check_car_driving_status(car_info)
            if not status:
                api_errors += 1
                continue

            # If parked with GPS, save it for future trip starts
            if status["is_parked"] and status.get("lat") and status.get("lng"):
                self.save_last_parked_gps(user_id, car_info["car_id"], status["lat"], status["lng"], timestamp, status.get("odometer"))

            if status["is_driving"]:
                # Add last parked GPS to status for trip start
                last_parked = self.get_last_parked_gps(user_id, car_info["car_id"])
                if last_parked:
                    status["last_parked_gps"] = last_parked
                    logger.info(f"Found driving car: {status['name']} with last parked GPS: {last_parked['lat']}, {last_parked['lng']}")
                else:
                    logger.info(f"Found driving car: {status['name']} (no last parked GPS)")
                return status, "driving"

        # All cars failed API check
        if api_errors == len(cars):
            logger.warning(f"All {api_errors} car API checks failed")
            return None, "api_error"

        logger.info("No cars are driving")
        return None, "parked"


# Singleton instance
car_service = CarService()
