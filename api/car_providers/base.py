from abc import ABC, abstractmethod
from dataclasses import dataclass
from enum import Enum


class VehicleState(Enum):
    UNKNOWN = "unknown"
    PARKED = "parked"
    DRIVING = "driving"
    CHARGING = "charging"


@dataclass
class CarData:
    """Unified car data structure across all providers"""
    vin: str | None = None
    odometer_km: float | None = None
    latitude: float | None = None
    longitude: float | None = None
    state: VehicleState = VehicleState.UNKNOWN
    battery_level: float | None = None  # percentage
    range_km: float | None = None
    charging_power_kw: float | None = None
    charging_remaining_minutes: int | None = None
    is_charging: bool = False
    is_plugged_in: bool = False
    raw_data: dict | None = None  # Full API response for debugging


class CarProvider(ABC):
    """Abstract base class for car API providers"""

    @property
    @abstractmethod
    def brand(self) -> str:
        """Return the brand name (e.g., 'audi', 'renault')"""
        pass

    @abstractmethod
    def connect(self) -> bool:
        """Connect to the car API. Returns True if successful."""
        pass

    @abstractmethod
    def get_data(self) -> CarData:
        """Fetch current car data including odometer, position, state, etc."""
        pass

    @abstractmethod
    def disconnect(self) -> None:
        """Clean up connection/resources"""
        pass

    def get_odometer(self) -> float | None:
        """Convenience method to get just the odometer"""
        return self.get_data().odometer_km

    def get_position(self) -> tuple[float, float] | None:
        """Convenience method to get just the position"""
        data = self.get_data()
        if data.latitude and data.longitude:
            return (data.latitude, data.longitude)
        return None
