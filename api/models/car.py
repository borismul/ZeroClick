"""
Car-related Pydantic models.
"""

from pydantic import BaseModel


class Car(BaseModel):
    """Car model for multi-car support."""
    id: str
    name: str
    brand: str = "other"  # audi, vw, skoda, seat, cupra, renault, tesla, bmw, mercedes, other
    color: str = "#3B82F6"  # Hex color for UI
    icon: str = "car"  # car, car-suv, car-sports, car-van, car-hatchback
    is_default: bool = False
    carplay_device_id: str | None = None  # For auto-detection
    start_odometer: float = 0  # Starting odometer for km verification per car
    created_at: str | None = None
    last_used: str | None = None
    # Stats (computed)
    total_trips: int = 0
    total_km: float = 0


class CarCreate(BaseModel):
    """Create a new car."""
    name: str
    brand: str = "other"
    color: str = "#3B82F6"
    icon: str = "car"
    start_odometer: float = 0


class CarUpdate(BaseModel):
    """Update car details."""
    name: str | None = None
    brand: str | None = None
    color: str | None = None
    icon: str | None = None
    is_default: bool | None = None
    carplay_device_id: str | None = None
    start_odometer: float | None = None


class CarCredentials(BaseModel):
    """Car API credentials."""
    brand: str = "audi"
    username: str = ""
    password: str = ""
    country: str = "NL"
    locale: str = "nl_NL"
    spin: str = ""
    start_odometer: float = 0


class CarTestRequest(BaseModel):
    """Test car credentials request."""
    brand: str = "audi"
    username: str
    password: str
    country: str = "NL"
