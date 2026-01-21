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
from .secrets import get_secret, get_secret_or_default, get_secret_or_env
from .encryption import encrypt_string, decrypt_string, encrypt_dict, decrypt_dict
from .errors import auth_error, oauth_error, validation_error, server_error

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
    # Secrets utilities
    "get_secret",
    "get_secret_or_default",
    "get_secret_or_env",
    # Encryption utilities
    "encrypt_string",
    "decrypt_string",
    "encrypt_dict",
    "decrypt_dict",
    # Error handling utilities
    "auth_error",
    "oauth_error",
    "validation_error",
    "server_error",
]
