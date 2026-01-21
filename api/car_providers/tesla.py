import logging
import json
from datetime import datetime

from .base import CarProvider, CarData, VehicleState

logger = logging.getLogger(__name__)


class TeslaProvider(CarProvider):
    """Tesla provider using TeslaPy library"""

    def __init__(self, email: str, refresh_token: str = None):
        self.email = email
        self._refresh_token = refresh_token
        self._tesla = None
        self._vehicle = None

    @property
    def brand(self) -> str:
        return "tesla"

    @property
    def display_name(self) -> str:
        return "Tesla"

    def _load_tokens_from_firestore(self) -> dict | None:
        """Load and decrypt cached tokens from Firestore."""
        try:
            from google.cloud import firestore
            from utils.encryption import decrypt_dict, is_encrypted
            db = firestore.Client()
            doc = db.collection("cache").document(f"tesla_tokens_{self.email}").get()
            if doc.exists:
                data = doc.to_dict()

                # Handle encrypted tokens (new format)
                if data and "tokens_encrypted" in data:
                    logger.info("Loading encrypted Tesla tokens from Firestore")
                    tokens = decrypt_dict(data["tokens_encrypted"])
                    return tokens

                # Handle legacy unencrypted tokens (migrate on read)
                if data and "tokens" in data:
                    logger.warning("Found unencrypted Tesla tokens - migrating to encrypted")
                    tokens = json.loads(data["tokens"])
                    self._save_tokens_to_firestore(tokens)  # Re-save encrypted
                    return tokens

        except Exception as e:
            logger.warning(f"Could not load tokens from Firestore: {e}")
        return None

    def _save_tokens_to_firestore(self, tokens: dict) -> None:
        """Save encrypted tokens to Firestore for persistence."""
        try:
            from google.cloud import firestore
            from utils.encryption import encrypt_dict
            db = firestore.Client()

            # ENCRYPT before storing
            encrypted_tokens = encrypt_dict(tokens)

            db.collection("cache").document(f"tesla_tokens_{self.email}").set({
                "tokens_encrypted": encrypted_tokens,
                "encryption_version": "kms-v1",
                "updated_at": datetime.utcnow().isoformat(),
            })
            logger.info("Saved encrypted Tesla tokens to Firestore")
        except Exception as e:
            logger.warning(f"Could not save tokens to Firestore: {e}")

    def get_authorization_url(self, callback_url: str) -> str:
        """Get Tesla OAuth authorization URL for user login."""
        import teslapy
        import os

        # Force English locale to avoid Chinese auth server
        os.environ['LANG'] = 'en_US.UTF-8'
        os.environ['LC_ALL'] = 'en_US.UTF-8'

        self._tesla = teslapy.Tesla(self.email)
        if not self._tesla.authorized:
            # Get the auth URL (uses default redirect_uri)
            auth_url = self._tesla.authorization_url()
            # Replace any Chinese auth server with the global one
            auth_url = auth_url.replace('auth.tesla.cn', 'auth.tesla.com')
            auth_url = auth_url.replace('/zh_cn/', '/')
            auth_url = auth_url.replace('zh-CN', 'en-US')
            return auth_url
        return None

    def complete_authorization(self, callback_url: str) -> bool:
        """Complete OAuth flow after user redirected back."""
        import teslapy

        if not self._tesla:
            self._tesla = teslapy.Tesla(self.email)

        try:
            self._tesla.fetch_token(authorization_response=callback_url)
            # Save tokens
            if hasattr(self._tesla, 'token') and self._tesla.token:
                self._save_tokens_to_firestore(self._tesla.token)
            return True
        except Exception as e:
            logger.error(f"Failed to complete Tesla authorization: {e}")
            return False

    def connect(self) -> bool:
        """Connect to Tesla API using cached tokens or refresh token."""
        import teslapy

        if not self.email:
            logger.error("Tesla email not configured")
            return False

        try:
            # Try to load cached tokens first
            cached_tokens = self._load_tokens_from_firestore()

            if cached_tokens:
                # Use cached tokens
                self._tesla = teslapy.Tesla(self.email)
                self._tesla.token = cached_tokens
                # Refresh if needed
                if self._tesla.token.get('expires_at', 0) < datetime.now().timestamp():
                    try:
                        self._tesla.refresh_token()
                        self._save_tokens_to_firestore(self._tesla.token)
                    except Exception as e:
                        logger.warning(f"Token refresh failed: {e}")
                        return False
                return True

            elif self._refresh_token:
                # Use provided refresh token
                self._tesla = teslapy.Tesla(self.email)
                self._tesla.token = {
                    'refresh_token': self._refresh_token,
                    'access_token': '',
                    'expires_at': 0
                }
                self._tesla.refresh_token()
                self._save_tokens_to_firestore(self._tesla.token)
                return True

            else:
                logger.error("No Tesla tokens available - authorization required")
                return False

        except Exception as e:
            logger.error(f"Failed to connect to Tesla: {e}")
            return False

    def get_vehicles(self) -> list[dict]:
        """Get list of vehicles for this account."""
        if not self._tesla:
            if not self.connect():
                return []

        try:
            vehicles = self._tesla.vehicle_list()
            return [
                {
                    "vin": v["vin"],
                    "name": v["display_name"],
                    "model": v["vehicle_state"].get("car_type", "Model ?") if "vehicle_state" in v else "Tesla",
                }
                for v in vehicles
            ]
        except Exception as e:
            logger.error(f"Failed to get Tesla vehicles: {e}")
            return []

    def get_data(self, vin: str = None) -> CarData:
        """Fetch current car data from Tesla API."""
        if not self._tesla:
            if not self.connect():
                return CarData()

        try:
            vehicles = self._tesla.vehicle_list()
            if not vehicles:
                logger.error("No Tesla vehicles found")
                return CarData()

            # Find vehicle by VIN or use first one
            vehicle = None
            for v in vehicles:
                if vin is None or v["vin"] == vin:
                    vehicle = v
                    break

            if not vehicle:
                logger.error(f"Tesla vehicle {vin} not found")
                return CarData()

            self._vehicle = vehicle

            # Wake up vehicle if needed (with timeout)
            try:
                if vehicle.get("state") != "online":
                    logger.info("Waking up Tesla...")
                    vehicle.sync_wake_up(timeout=30)
            except Exception as e:
                logger.warning(f"Could not wake Tesla: {e}")
                # Continue anyway - we might get cached data

            # Get vehicle data
            try:
                data = vehicle.get_vehicle_data()
            except Exception as e:
                logger.warning(f"Could not get live data, using cached: {e}")
                data = vehicle

            # Extract data
            vehicle_state = data.get("vehicle_state", {})
            charge_state = data.get("charge_state", {})
            drive_state = data.get("drive_state", {})

            # Determine state
            state = VehicleState.UNKNOWN
            if drive_state.get("shift_state") in ["D", "R", "N"]:
                state = VehicleState.DRIVING
            elif charge_state.get("charging_state") == "Charging":
                state = VehicleState.CHARGING
            else:
                state = VehicleState.PARKED

            # Save updated tokens
            if hasattr(self._tesla, 'token') and self._tesla.token:
                self._save_tokens_to_firestore(self._tesla.token)

            return CarData(
                vin=data.get("vin"),
                odometer_km=self._miles_to_km(vehicle_state.get("odometer")),
                latitude=drive_state.get("latitude"),
                longitude=drive_state.get("longitude"),
                state=state,
                battery_level=charge_state.get("battery_level"),
                range_km=self._miles_to_km(charge_state.get("battery_range")),
                is_charging=charge_state.get("charging_state") == "Charging",
                charging_power_kw=charge_state.get("charger_power"),
                charging_remaining_minutes=charge_state.get("minutes_to_full_charge"),
                is_plugged_in=charge_state.get("charge_port_door_open", False),
                raw_data=data,
            )

        except Exception as e:
            logger.error(f"Error fetching Tesla data: {e}")
            import traceback
            logger.error(traceback.format_exc())
            return CarData()

    def _miles_to_km(self, miles: float | None) -> float | None:
        """Convert miles to kilometers."""
        if miles is None:
            return None
        return miles * 1.60934

    def disconnect(self) -> None:
        """Clean up connection."""
        if self._tesla:
            try:
                self._tesla.close()
            except Exception:
                pass
            self._tesla = None
            self._vehicle = None
