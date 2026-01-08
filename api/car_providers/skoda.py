"""Skoda provider using OAuth tokens with MySkoda API"""

import logging
import requests

from .base import CarProvider, CarData, VehicleState

logger = logging.getLogger(__name__)

BASE_URL = "https://mysmob.api.connect.skoda-auto.cz/api"


class SkodaOAuthProvider(CarProvider):
    """Skoda provider using OAuth tokens"""

    def __init__(self, access_token: str, id_token: str | None = None):
        self._access_token = access_token
        self._id_token = id_token
        self._session = requests.Session()
        self._session.headers.update({
            "Authorization": f"Bearer {access_token}",
            "Accept": "application/json",
            "Content-Type": "application/json",
        })
        self._vehicles = []

    @property
    def brand(self) -> str:
        return "skoda"

    def connect(self) -> bool:
        """Verify connection by fetching vehicles"""
        try:
            self._vehicles = self._get_vehicles()
            return len(self._vehicles) > 0
        except Exception as e:
            logger.error(f"Failed to connect to Skoda: {e}")
            return False

    def _get_vehicles(self) -> list:
        """Get list of vehicles"""
        try:
            resp = self._session.get(f"{BASE_URL}/v2/garage")
            resp.raise_for_status()
            data = resp.json()
            vehicles = data.get("vehicles", [])
            logger.info(f"Found {len(vehicles)} Skoda vehicles")
            return vehicles
        except Exception as e:
            logger.error(f"Failed to get Skoda vehicles: {e}")
            return []

    def get_data(self) -> CarData:
        """Fetch current car data"""
        if not self._vehicles:
            self._vehicles = self._get_vehicles()

        if not self._vehicles:
            logger.error("No Skoda vehicles found")
            return CarData()

        vehicle = self._vehicles[0]
        vin = vehicle.get("vin")

        if not vin:
            logger.error("No VIN found for Skoda vehicle")
            return CarData()

        try:
            # Get vehicle status
            status_resp = self._session.get(f"{BASE_URL}/v2/vehicle-status/{vin}")
            status_resp.raise_for_status()
            status = status_resp.json()

            # Get charging status for EVs
            charging = {}
            try:
                charging_resp = self._session.get(f"{BASE_URL}/v1/charging/{vin}/status")
                if charging_resp.status_code == 200:
                    charging = charging_resp.json()
            except:
                pass

            # Extract data
            odometer = None
            if "mileageInKm" in status:
                odometer = status["mileageInKm"]

            # Position
            lat, lng = None, None
            if "remote" in status and "capturedAt" in status["remote"]:
                # Position might be in different places
                pass

            # Battery/range for EVs
            battery_level = None
            range_km = None
            is_charging = False
            is_plugged_in = False

            if charging:
                battery_level = charging.get("battery", {}).get("stateOfChargeInPercent")
                range_km = charging.get("battery", {}).get("cruisingRangeElectricInMeters")
                if range_km:
                    range_km = range_km / 1000  # Convert to km

                charging_state = charging.get("state")
                is_charging = charging_state == "CHARGING"
                is_plugged_in = charging.get("plug", {}).get("connectionState") == "CONNECTED"

            # Try to get range from status if not in charging
            if range_km is None and "remote" in status:
                remote = status["remote"]
                if "electricRange" in remote:
                    range_km = remote["electricRange"]

            return CarData(
                vin=vin,
                odometer_km=odometer,
                latitude=lat,
                longitude=lng,
                state=VehicleState.CHARGING if is_charging else VehicleState.PARKED,
                battery_level=battery_level,
                range_km=range_km,
                is_charging=is_charging,
                is_plugged_in=is_plugged_in,
                raw_data={"status": status, "charging": charging},
            )

        except Exception as e:
            logger.error(f"Failed to get Skoda data: {e}")
            import traceback
            logger.error(traceback.format_exc())
            return CarData()

    def disconnect(self) -> None:
        """Close session"""
        self._session.close()
