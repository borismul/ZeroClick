"""
Configuration module for mileage-tracker API.
Centralizes all environment variables, constants, and settings.
"""

import os
from dataclasses import dataclass, field


# === Google OAuth Client IDs ===
GOOGLE_CLIENT_IDS = [
    cid for cid in [
        os.environ.get("GOOGLE_OAUTH_CLIENT_ID", ""),
        os.environ.get("GOOGLE_WEB_CLIENT_ID", ""),
        os.environ.get("GOOGLE_IOS_CLIENT_ID", ""),
    ] if cid
]

# === Auth Settings ===
AUTH_ENABLED = os.environ.get("AUTH_ENABLED", "false").lower() == "true"


@dataclass
class LocationConfig:
    """Configuration for a known location."""
    lat: float
    lon: float
    radius: int = 150
    is_business: bool = True


@dataclass
class Config:
    """Main configuration loaded from environment variables."""
    project_id: str = field(default_factory=lambda: os.environ.get("PROJECT_ID", ""))
    maps_api_key: str = field(default_factory=lambda: os.environ.get("MAPS_API_KEY", ""))

    # Known locations
    home_lat: float = field(default_factory=lambda: float(os.environ.get("CONFIG_HOME_LAT", 0)))
    home_lon: float = field(default_factory=lambda: float(os.environ.get("CONFIG_HOME_LON", 0)))
    office_lat: float = field(default_factory=lambda: float(os.environ.get("CONFIG_OFFICE_LAT", 0)))
    office_lon: float = field(default_factory=lambda: float(os.environ.get("CONFIG_OFFICE_LON", 0)))

    # Skip location (e.g., daycare - intermediate stop that doesn't end a trip)
    skip_lat: float = field(default_factory=lambda: float(os.environ.get("CONFIG_SKIP_LAT", 0)))
    skip_lon: float = field(default_factory=lambda: float(os.environ.get("CONFIG_SKIP_LON", 0)))
    skip_radius: int = 200  # Slightly larger radius for intermediate stops

    # Trip settings
    start_odometer: float = field(default_factory=lambda: float(os.environ.get("CONFIG_START_ODOMETER", 0)))
    private_days: list[int] = field(default_factory=lambda: [5, 6])  # Saturday, Sunday
    min_trip_km: float = 0.1

    @property
    def locations(self) -> dict[str, LocationConfig]:
        """Built-in locations (Thuis, Kantoor)."""
        return {
            "Thuis": LocationConfig(
                lat=self.home_lat,
                lon=self.home_lon,
                radius=150,
                is_business=False,
            ),
            "Kantoor": LocationConfig(
                lat=self.office_lat,
                lon=self.office_lon,
                radius=150,
                is_business=True,
            ),
        }

    @property
    def skip_location(self) -> dict:
        """Skip location configuration."""
        return {
            "lat": self.skip_lat,
            "lon": self.skip_lon,
            "radius": self.skip_radius,
        }


# Singleton config instance
config = Config()

# Legacy CONFIG dict for backwards compatibility during migration
CONFIG = {
    "project_id": config.project_id,
    "maps_api_key": config.maps_api_key,
    "locations": {
        "Thuis": {
            "lat": config.home_lat,
            "lon": config.home_lon,
            "radius": 150,
            "is_business": False,
        },
        "Kantoor": {
            "lat": config.office_lat,
            "lon": config.office_lon,
            "radius": 150,
            "is_business": True,
        },
    },
    "skip_location": {
        "lat": config.skip_lat,
        "lon": config.skip_lon,
        "radius": 200,
    },
    "start_odometer": config.start_odometer,
    "private_days": [5, 6],
    "min_trip_km": 0.1,
}


# === Constants ===

# Trip tracking
STALE_TRIP_HOURS = 2  # Trips with no activity for 2+ hours are considered stale

# GPS-based trip detection
GPS_STATIONARY_TIMEOUT_MINUTES = 5   # Auto-end trip after 5 min stationary (was 30)
GPS_STATIONARY_RADIUS_METERS = 50    # Consider stationary if within 50m
TRIP_RESUME_WINDOW_MINUTES = 30      # Resume trip if driving again within 30 min of stop

# Charging stations cache
CHARGING_CACHE_TTL = 300  # 5 minutes

# Open Charge Map API
OPENCHARGEMAP_API_KEY = os.environ.get("OPENCHARGEMAP_API_KEY", "")


# === VW Group OAuth Configurations ===

VW_GROUP_OAUTH_CONFIG = {
    "volkswagen": {
        "client_id": "a24fba63-34b3-4d43-b181-942111e6bda8@apps_vw-dilab_com",
        "redirect_uri": "weconnect://authenticated",
        "scope": "openid profile badge cars dealers vin",
        "response_type": "code id_token token",
        "name": "Volkswagen We Connect",
    },
    "skoda": {
        "client_id": "7f045eee-7003-4379-9968-9355ed2adb06@apps_vw-dilab_com",
        "redirect_uri": "myskoda://redirect/login/",
        "scope": "openid profile address badge birthdate cars dealers driversLicense email mbb mileage nationalIdentifier phone profession vin",
        "response_type": "code",
        "name": "MySkoda",
    },
    "seat": {
        "client_id": "3c8e98bc-3ae9-4277-a563-d5ee65ddebba@apps_vw-dilab_com",
        "redirect_uri": "seatconnect://identity-kit/login",
        "scope": "openid profile",
        "response_type": "code id_token",
        "name": "SEAT Connect",
    },
    "cupra": {
        "client_id": "30e33736-c537-4c72-ab60-74a7b92cfe83@apps_vw-dilab_com",
        "redirect_uri": "cupraconnect://identity-kit/login",
        "scope": "openid profile address phone email birthdate nationalIdentifier cars mbb dealers badge nationality",
        "response_type": "code id_token token",
        "name": "CUPRA Connect",
    },
}


# === Renault Gigya Configuration ===


def _load_renault_gigya_config() -> dict:
    """Load Renault Gigya config from Secret Manager."""
    from utils.secrets import get_secret_or_default
    api_key = get_secret_or_default("renault-gigya-api-key", "")
    return {
        "api_key": api_key,
        "gigya_url": "https://accounts.eu1.gigya.com",
        "login_url": "https://idconnect.renaultgroup.com/{locale}/authentication-portal/login-signup.html",
        "success_url": "https://idconnect.renaultgroup.com/{locale}/authentication-portal/login-signup/success.html",
    }


def _load_renault_gigya_api_keys() -> dict:
    """Load Renault Gigya API keys per locale from Secret Manager."""
    import json
    from utils.secrets import get_secret_or_default
    keys_json = get_secret_or_default("renault-gigya-api-keys", "{}")
    try:
        return json.loads(keys_json)
    except json.JSONDecodeError:
        return {}


# Lazy-loaded Renault config (loaded on first access)
_renault_gigya_config: dict | None = None
_renault_gigya_api_keys: dict | None = None


def get_renault_gigya_config() -> dict:
    """Get Renault Gigya config, loading from Secret Manager on first access."""
    global _renault_gigya_config
    if _renault_gigya_config is None:
        _renault_gigya_config = _load_renault_gigya_config()
    return _renault_gigya_config


def get_renault_gigya_api_keys() -> dict:
    """Get Renault Gigya API keys, loading from Secret Manager on first access."""
    global _renault_gigya_api_keys
    if _renault_gigya_api_keys is None:
        _renault_gigya_api_keys = _load_renault_gigya_api_keys()
    return _renault_gigya_api_keys


