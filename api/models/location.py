"""
Location-related Pydantic models.
"""

from pydantic import BaseModel, field_validator


class WebhookLocation(BaseModel):
    """GPS location from webhook request."""
    lat: float
    lng: float

    @field_validator('lat')
    @classmethod
    def validate_lat(cls, v):
        if not -90 <= v <= 90:
            raise ValueError(f'Latitude must be between -90 and 90, got {v}')
        return v

    @field_validator('lng')
    @classmethod
    def validate_lng(cls, v):
        if not -180 <= v <= 180:
            raise ValueError(f'Longitude must be between -180 and 180, got {v}')
        return v


class CustomLocation(BaseModel):
    """Custom named location."""
    name: str
    lat: float
    lng: float
