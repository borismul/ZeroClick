"""
Utility functions for mileage-tracker API.
"""

from .geo import haversine, calculate_gps_distance, get_gps_distance_from_trail
from .routing import (
    get_osrm_distance_from_trail,
    get_google_maps_route_distance,
    calculate_route_deviation,
)
from .ids import generate_id

__all__ = [
    # Geo utilities
    "haversine",
    "calculate_gps_distance",
    "get_gps_distance_from_trail",
    # Routing utilities
    "get_osrm_distance_from_trail",
    "get_google_maps_route_distance",
    "calculate_route_deviation",
    # ID utilities
    "generate_id",
]
