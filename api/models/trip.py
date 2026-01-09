"""
Trip-related Pydantic models.
"""

from pydantic import BaseModel


class TripEvent(BaseModel):
    """Legacy webhook event for simple trip start/end."""
    event: str
    lat: float
    lon: float
    timestamp: str


class GpsPoint(BaseModel):
    """GPS coordinate with optional timestamp."""
    lat: float
    lng: float
    timestamp: str | None = None


class Trip(BaseModel):
    """Complete trip record."""
    id: str
    date: str
    start_time: str
    end_time: str
    from_address: str
    to_address: str
    from_lat: float | None = None
    from_lon: float | None = None
    to_lat: float | None = None
    to_lon: float | None = None
    distance_km: float
    trip_type: str
    business_km: float
    private_km: float
    start_odo: float
    end_odo: float
    notes: str = ""
    created_at: str | None = None
    car_id: str | None = None  # "audi", "prive", or "unknown" (show red in UI)
    gps_trail: list[GpsPoint] = []  # Route waypoints for Google Maps
    google_maps_km: float | None = None  # Shortest route distance from Google Maps
    route_deviation_percent: float | None = None  # How much longer than Google Maps route (%)
    route_flag: str | None = None  # "long_route" if significantly longer than Google Maps
    distance_source: str | None = None  # "odometer", "osrm", or "gps" - how distance was calculated


class TripUpdate(BaseModel):
    """Partial update for a trip."""
    date: str | None = None
    start_time: str | None = None
    end_time: str | None = None
    from_address: str | None = None
    to_address: str | None = None
    distance_km: float | None = None
    trip_type: str | None = None
    business_km: float | None = None
    private_km: float | None = None
    notes: str | None = None
    route_flag: str | None = None  # Can be set to "long_route" or null
    car_id: str | None = None


class ManualTrip(BaseModel):
    """Manual trip creation request."""
    date: str
    start_time: str = "09:00"
    end_time: str = "10:00"
    from_address: str
    to_address: str
    distance_km: float
    trip_type: str = "B"
    car_id: str | None = None


class FullTrip(BaseModel):
    """Trip with all details including GPS trail (for recovery)."""
    date: str
    start_time: str
    end_time: str
    from_lat: float
    from_lon: float
    to_lat: float
    to_lon: float
    distance_km: float
    trip_type: str = "P"
    start_odo: float
    end_odo: float
    car_id: str | None = None
    gps_trail: list[GpsPoint] = []
