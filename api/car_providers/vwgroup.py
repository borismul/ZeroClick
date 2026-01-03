import logging
import os
import tempfile
from datetime import datetime

from .base import CarProvider, CarData, VehicleState

logger = logging.getLogger(__name__)

# Mapping of brand names to CarConnectivity connector types
BRAND_CONNECTORS = {
    "audi": "audi",
    "volkswagen": "volkswagen",
    "vw": "volkswagen",
    "skoda": "skoda",
    "seat": "seatcupra",
    "cupra": "seatcupra",
}

BRAND_DISPLAY_NAMES = {
    "audi": "Audi",
    "volkswagen": "Volkswagen",
    "vw": "Volkswagen",
    "skoda": "Skoda",
    "seat": "Seat",
    "cupra": "Cupra",
}


class VWGroupProvider(CarProvider):
    """VW Group provider (Audi, VW, Skoda, Seat, Cupra) using CarConnectivity library"""

    def __init__(self, brand: str, username: str, password: str, country: str = "NL", spin: str = ""):
        self._brand = brand.lower()
        self.username = username
        self.password = password
        self.country = country
        self.spin = spin
        self._cc = None
        self._vehicle = None
        self._connector_type = BRAND_CONNECTORS.get(self._brand, self._brand)
        self._tokenstore = os.path.join(tempfile.gettempdir(), f"{self._connector_type}_tokenstore")

    @property
    def brand(self) -> str:
        return self._brand

    @property
    def display_name(self) -> str:
        return BRAND_DISPLAY_NAMES.get(self._brand, self._brand.title())

    def _load_tokens_from_firestore(self) -> bool:
        """Load cached tokens from Firestore to local file. Returns True if tokens found."""
        try:
            from google.cloud import firestore
            db = firestore.Client()
            doc = db.collection("cache").document(f"{self._connector_type}_tokens").get()
            if doc.exists:
                data = doc.to_dict()
                if data and "tokens" in data:
                    with open(self._tokenstore, "w") as f:
                        f.write(data["tokens"])
                    logger.info(f"Loaded {self.display_name} tokens from Firestore")
                    return True
        except Exception as e:
            logger.warning(f"Could not load tokens from Firestore: {e}")
        return False

    def _save_tokens_to_firestore(self) -> None:
        """Save local tokens to Firestore for persistence across cold starts."""
        try:
            from google.cloud import firestore
            if os.path.exists(self._tokenstore):
                with open(self._tokenstore, "r") as f:
                    tokens = f.read()
                if tokens:
                    db = firestore.Client()
                    db.collection("cache").document(f"{self._connector_type}_tokens").set({
                        "tokens": tokens,
                        "updated_at": datetime.utcnow().isoformat(),
                    })
                    logger.info(f"Saved {self.display_name} tokens to Firestore")
        except Exception as e:
            logger.warning(f"Could not save tokens to Firestore: {e}")

    def connect(self) -> bool:
        """Connect to VW Group API"""
        from carconnectivity.carconnectivity import CarConnectivity

        if not self.username or not self.password:
            logger.error(f"{self.display_name} credentials not configured")
            return False

        try:
            logger.info(f"Connecting to {self.display_name} via CarConnectivity...")

            cc_config = {
                "carConnectivity": {
                    "connectors": [
                        {
                            "type": self._connector_type,
                            "config": {
                                "username": self.username,
                                "password": self.password,
                            }
                        }
                    ]
                }
            }

            # Try to load cached tokens from Firestore
            self._load_tokens_from_firestore()

            self._cc = CarConnectivity(config=cc_config, tokenstore_file=self._tokenstore)
            return True

        except Exception as e:
            logger.error(f"Failed to connect to {self.display_name}: {e}")
            return False

    def get_data(self) -> CarData:
        """Fetch current car data from VW Group API"""
        if not self._cc:
            if not self.connect():
                return CarData()

        try:
            logger.info(f"Fetching {self.display_name} vehicle data...")
            self._cc.fetch_all()

            garage = self._cc.get_garage()
            if garage is None:
                logger.error("No garage found")
                return CarData()

            vehicles = list(garage.list_vehicles())
            if not vehicles:
                logger.error("No vehicles found")
                return CarData()

            vehicle = vehicles[0]
            self._vehicle = vehicle

            # Extract VIN
            vin = vehicle.vin.value if hasattr(vehicle.vin, 'value') else str(vehicle.vin)

            # Extract odometer
            odometer = self._extract_odometer(vehicle)

            # Extract position
            lat, lng = self._extract_position(vehicle)

            # Extract state
            state = self._extract_state(vehicle)

            # Extract battery info
            battery_level, range_km, is_charging, charging_power, charging_remaining_minutes, is_plugged_in = self._extract_battery_info(vehicle)

            # Get full dict for debugging
            raw_data = None
            if hasattr(vehicle, 'as_dict'):
                raw_data = vehicle.as_dict()

            # Save tokens for next cold start
            self._save_tokens_to_firestore()

            return CarData(
                vin=vin,
                odometer_km=odometer,
                latitude=lat,
                longitude=lng,
                state=state,
                battery_level=battery_level,
                range_km=range_km,
                is_charging=is_charging,
                charging_power_kw=charging_power,
                charging_remaining_minutes=charging_remaining_minutes,
                is_plugged_in=is_plugged_in,
                raw_data=raw_data,
            )

        except Exception as e:
            logger.error(f"Error fetching {self.display_name} data: {e}")
            import traceback
            logger.error(traceback.format_exc())
            return CarData()

    def _extract_odometer(self, vehicle) -> float | None:
        """Extract odometer from vehicle object"""
        odometer = None

        # Direct odometer attribute
        if hasattr(vehicle, 'odometer') and vehicle.odometer:
            odo = vehicle.odometer
            odometer = odo.value if hasattr(odo, 'value') else odo

        # Via status/state
        if odometer is None and hasattr(vehicle, 'status'):
            status = vehicle.status
            if hasattr(status, 'odometer'):
                odo = status.odometer
                odometer = odo.value if hasattr(odo, 'value') else odo

        # Via domains
        if odometer is None and hasattr(vehicle, 'domains'):
            for domain in vehicle.domains.values():
                if hasattr(domain, 'odometer'):
                    odo = domain.odometer
                    odometer = odo.value if hasattr(odo, 'value') else odo
                    break

        return odometer

    def _extract_position(self, vehicle) -> tuple[float | None, float | None]:
        """Extract GPS position from vehicle object"""
        lat, lng = None, None

        try:
            if hasattr(vehicle, 'as_dict'):
                vd = vehicle.as_dict()
                if 'position' in vd:
                    pos = vd['position']
                    if 'latitude' in pos and 'val' in pos['latitude']:
                        lat = pos['latitude']['val']
                    if 'longitude' in pos and 'val' in pos['longitude']:
                        lng = pos['longitude']['val']
        except Exception as e:
            logger.warning(f"Could not extract position: {e}")

        return lat, lng

    def _extract_state(self, vehicle) -> VehicleState:
        """Extract vehicle state"""
        try:
            if hasattr(vehicle, 'as_dict'):
                vd = vehicle.as_dict()
                if 'state' in vd and 'val' in vd['state']:
                    state_str = str(vd['state']['val']).lower()
                    if 'parked' in state_str or 'parking' in state_str:
                        return VehicleState.PARKED
                    elif 'driving' in state_str or 'ignition' in state_str:
                        return VehicleState.DRIVING
                    elif 'charging' in state_str:
                        return VehicleState.CHARGING
        except Exception as e:
            logger.warning(f"Could not extract state: {e}")

        return VehicleState.UNKNOWN

    def _extract_battery_info(self, vehicle) -> tuple[float | None, float | None, bool, float | None, int | None, bool]:
        """Extract battery level, range, charging status, charging power, remaining time, and plug status"""
        battery_level = None
        range_km = None
        is_charging = False
        charging_power = None
        charging_remaining_minutes = None
        is_plugged_in = False

        # Helper to extract string value from Enum or string
        def get_str_val(obj):
            if hasattr(obj, 'value'):
                return str(obj.value).lower()
            elif hasattr(obj, 'name'):
                return str(obj.name).lower()
            return str(obj).lower()

        try:
            if hasattr(vehicle, 'as_dict'):
                vd = vehicle.as_dict()

                # Battery level from drives.primary.level
                if 'drives' in vd and 'primary' in vd['drives']:
                    primary = vd['drives']['primary']
                    if 'level' in primary and 'val' in primary['level']:
                        battery_level = primary['level']['val']
                    if 'range' in primary and 'val' in primary['range']:
                        range_km = primary['range']['val']

                # Total range
                if range_km is None and 'drives' in vd:
                    if 'total_range' in vd['drives'] and 'val' in vd['drives']['total_range']:
                        range_km = vd['drives']['total_range']['val']

                # Charging info from charging section
                if 'charging' in vd:
                    charging = vd['charging']

                    # Charging state
                    if 'state' in charging and 'val' in charging['state']:
                        charging_state = get_str_val(charging['state']['val'])
                        is_charging = charging_state == 'charging'

                    # Charging power
                    if 'power' in charging and 'val' in charging['power']:
                        charging_power = charging['power']['val']

                    # Remaining charging time
                    if 'remaining_time' in charging and 'val' in charging['remaining_time']:
                        charging_remaining_minutes = charging['remaining_time']['val']

                    # Plug/connector status
                    if 'connector' in charging:
                        connector = charging['connector']
                        if 'connection_state' in connector and 'val' in connector['connection_state']:
                            conn_state = get_str_val(connector['connection_state']['val'])
                            is_plugged_in = conn_state == 'connected'

        except Exception as e:
            logger.warning(f"Could not extract battery info: {e}")

        return battery_level, range_km, is_charging, charging_power, charging_remaining_minutes, is_plugged_in

    def disconnect(self) -> None:
        """Shutdown the connection"""
        if self._cc:
            try:
                self._cc.shutdown()
            except Exception as e:
                logger.warning(f"Error during disconnect: {e}")
            self._cc = None
            self._vehicle = None


# Backwards compatibility alias
AudiProvider = VWGroupProvider
