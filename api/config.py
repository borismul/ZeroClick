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
GPS_STATIONARY_TIMEOUT_MINUTES = 30  # Auto-end trip after 30 min stationary
GPS_STATIONARY_RADIUS_METERS = 50    # Consider stationary if within 50m

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

RENAULT_GIGYA_CONFIG = {
    "api_key": "3_4LKbCcMMcvjDm3X89LU4z4mNKYKdl_W0oD9w-Jvih21WqgJKtFZAnb9YdUgWT9_a",
    "gigya_url": "https://accounts.eu1.gigya.com",
    "login_url": "https://idconnect.renaultgroup.com/{locale}/authentication-portal/login-signup.html",
    "success_url": "https://idconnect.renaultgroup.com/{locale}/authentication-portal/login-signup/success.html",
}

# Renault Gigya API keys per locale
RENAULT_GIGYA_API_KEYS = {
    "nl_NL": "3_ZSMbhKpLMvjMcFB6NWTO2dj91RCQF1d3sRLHmWGJPGUHeZcCZd-0x-Vb4r_bYeYh",
    "fr_FR": "3_4LKbCcMMcvjDm3X89LU4z4mNKYKdl_W0oD9w-Jvih21WqgJKtFZAnb9YdUgWT9_a",
    "de_DE": "3_7PLksOyBRkHv126x5WhHb-5pqC1qFR8pQjxSeLB6nhAnPERTUlwnYoznHSxwX668",
    "en_GB": "3_e8d4g4SE_Fo8ahyHwwP7ohLGZ79HKNN2T8NjQqoNnk6Epj6ilyYwKdHUyCw3wuxz",
    "es_ES": "3_DyMiOwEaxLcPdBTu63Gv3hlhvLaLbW3ufvjHLeuU8U5bx7clnPKZwUf5u0GZAVrq",
    "it_IT": "3_js8th3jdmCWV86fKR3SXQWvXGKbHoWFv8NAgRbH7FnIBsi_XvCpN_rtLcI07uNuq",
    "pt_PT": "3_js8th3jdmCWV86fKR3SXQWvXGKbHoWFv8NAgRbH7FnIBsi_XvCpN_rtLcI07uNuq",
    "be_BE": "3_ZSMbhKpLMvjMcFB6NWTO2dj91RCQF1d3sRLHmWGJPGUHeZcCZd-0x-Vb4r_bYeYh",
}
