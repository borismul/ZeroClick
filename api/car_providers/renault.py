import asyncio
import logging
from datetime import datetime

from .base import CarProvider, CarData, VehicleState

logger = logging.getLogger(__name__)


class RenaultProvider(CarProvider):
    """Renault provider using renault-api library"""

    def __init__(self, username: str, password: str, locale: str = "nl_NL", vin: str = ""):
        self.username = username
        self.password = password
        self.locale = locale
        self.vin = vin  # Optional, will use first vehicle if not set
        self._account_id = None
        self._cached_data: CarData | None = None

    @property
    def brand(self) -> str:
        return "renault"

    def connect(self) -> bool:
        """Test connection to Renault API"""
        if not self.username or not self.password:
            logger.error("Renault credentials not configured")
            return False

        try:
            # Run async connection test
            asyncio.run(self._async_connect_test())
            return True
        except Exception as e:
            logger.error(f"Failed to connect to Renault: {e}")
            return False

    async def _async_connect_test(self):
        """Async connection test"""
        import aiohttp
        from renault_api.renault_client import RenaultClient

        async with aiohttp.ClientSession() as session:
            client = RenaultClient(websession=session, locale=self.locale)
            await client.session.login(self.username, self.password)
            logger.info("Renault login successful")

    def get_data(self) -> CarData:
        """Fetch current car data from Renault API"""
        try:
            return asyncio.run(self._async_get_data())
        except Exception as e:
            logger.error(f"Error fetching Renault data: {e}")
            import traceback
            logger.error(traceback.format_exc())
            return CarData()

    async def _async_get_data(self) -> CarData:
        """Async implementation of get_data"""
        import aiohttp
        from renault_api.renault_client import RenaultClient

        async with aiohttp.ClientSession() as session:
            client = RenaultClient(websession=session, locale=self.locale)
            await client.session.login(self.username, self.password)

            # Get account
            person = await client.get_person()
            if not person.accounts:
                logger.error("No Renault accounts found")
                return CarData()

            account_id = person.accounts[0].accountId
            account = await client.get_api_account(account_id)

            # Get vehicles
            vehicles = await account.get_vehicles()
            if not vehicles.vehicleLinks:
                logger.error("No vehicles found")
                return CarData()

            # Find the right vehicle
            vehicle_link = vehicles.vehicleLinks[0]
            if self.vin:
                for vl in vehicles.vehicleLinks:
                    if vl.vin == self.vin:
                        vehicle_link = vl
                        break

            vin = vehicle_link.vin
            vehicle = await account.get_api_vehicle(vin)

            # Gather all data
            odometer = None
            battery_level = None
            range_km = None
            is_charging = False
            is_plugged_in = False
            charging_power = None
            charging_remaining_minutes = None
            battery_temp = None
            lat, lng = None, None
            state = VehicleState.UNKNOWN
            hvac_status = None
            raw_data = {}

            # Get cockpit data (odometer, fuel/battery level)
            try:
                cockpit = await vehicle.get_cockpit()
                if cockpit:
                    raw_data['cockpit'] = cockpit.__dict__ if hasattr(cockpit, '__dict__') else str(cockpit)
                    if hasattr(cockpit, 'totalMileage'):
                        odometer = cockpit.totalMileage
            except Exception as e:
                logger.warning(f"Could not get cockpit data: {e}")

            # Get battery status
            try:
                battery = await vehicle.get_battery_status()
                if battery:
                    raw_data['battery'] = battery.__dict__ if hasattr(battery, '__dict__') else str(battery)
                    if hasattr(battery, 'batteryLevel'):
                        battery_level = battery.batteryLevel
                    if hasattr(battery, 'batteryAutonomy'):
                        range_km = battery.batteryAutonomy
                    if hasattr(battery, 'batteryTemperature'):
                        battery_temp = battery.batteryTemperature
                    if hasattr(battery, 'chargingStatus'):
                        charging_val = battery.chargingStatus
                        # chargingStatus can be a float (1.0 = charging) or string
                        is_charging = charging_val == 1.0 or charging_val == 1 or str(charging_val).lower() in ('charging', '1', '1.0')
                    if hasattr(battery, 'plugStatus'):
                        plug_val = battery.plugStatus
                        is_plugged_in = plug_val == 1.0 or plug_val == 1 or str(plug_val).lower() in ('plugged', '1', '1.0')
                    if hasattr(battery, 'chargingInstantaneousPower'):
                        charging_power = battery.chargingInstantaneousPower
                        # Convert from W to kW if needed
                        if charging_power and charging_power > 100:
                            charging_power = charging_power / 1000
                    if hasattr(battery, 'chargingRemainingTime'):
                        charging_remaining_minutes = battery.chargingRemainingTime
            except Exception as e:
                logger.warning(f"Could not get battery status: {e}")

            # Get HVAC status
            try:
                hvac = await vehicle.get_hvac_status()
                if hvac:
                    raw_data['hvac'] = hvac.__dict__ if hasattr(hvac, '__dict__') else str(hvac)
                    if hasattr(hvac, 'hvacStatus'):
                        hvac_status = hvac.hvacStatus
            except Exception as e:
                logger.warning(f"Could not get HVAC status: {e}")

            # Get location
            try:
                location = await vehicle.get_location()
                if location:
                    raw_data['location'] = location.__dict__ if hasattr(location, '__dict__') else str(location)
                    if hasattr(location, 'gpsLatitude'):
                        lat = location.gpsLatitude
                    if hasattr(location, 'gpsLongitude'):
                        lng = location.gpsLongitude
            except Exception as e:
                logger.warning(f"Could not get location: {e}")

            # Build unified raw_data structure (similar to Audi format for main.py parsing)
            raw_data['renault'] = {
                'battery_temp_celsius': battery_temp,
                'hvac_status': hvac_status,
            }

            # Determine state
            if is_charging:
                state = VehicleState.CHARGING
            elif lat and lng:
                state = VehicleState.PARKED  # If we have location, it's likely parked

            return CarData(
                vin=vin,
                odometer_km=odometer,
                latitude=lat,
                longitude=lng,
                state=state,
                battery_level=battery_level,
                range_km=range_km,
                is_charging=is_charging,
                is_plugged_in=is_plugged_in,
                charging_power_kw=charging_power,
                charging_remaining_minutes=charging_remaining_minutes,
                raw_data=raw_data,
            )

    def disconnect(self) -> None:
        """No persistent connection to close"""
        pass
