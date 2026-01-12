"""
OAuth-related Pydantic models for car manufacturer authentication.
"""

from pydantic import BaseModel


# === Audi OAuth ===

class AudiAuthRequest(BaseModel):
    """Request to start Audi OAuth flow."""
    car_id: str


class AudiCallbackRequest(BaseModel):
    """Audi OAuth callback with redirect URL containing tokens."""
    car_id: str
    redirect_url: str  # The full myaudi:///... URL with tokens


# === VW Group OAuth (Volkswagen, Skoda, SEAT, CUPRA) ===

class VWGroupAuthRequest(BaseModel):
    """Request to start VW Group OAuth flow."""
    car_id: str
    brand: str  # volkswagen, skoda, seat, cupra


class VWGroupCallbackRequest(BaseModel):
    """VW Group OAuth callback."""
    car_id: str
    brand: str
    redirect_url: str


# === Renault OAuth (Gigya-based) ===

class RenaultAuthRequest(BaseModel):
    """Request to start Renault OAuth flow."""
    car_id: str
    locale: str = "nl/nl"  # Format: language/country


class RenaultCallbackRequest(BaseModel):
    """Renault OAuth callback with Gigya token."""
    car_id: str
    gigya_token: str  # The login_token from Gigya
    gigya_person_id: str | None = None


class RenaultLoginRequest(BaseModel):
    """Direct Renault login via Gigya API (username/password)."""
    car_id: str
    username: str
    password: str
    locale: str = "nl_NL"


# === API Token Management ===

class TokenRequest(BaseModel):
    """Request to exchange Google ID token for API tokens."""
    google_token: str


class TokenResponse(BaseModel):
    """Response containing API access and refresh tokens."""
    access_token: str
    refresh_token: str
    token_type: str = "Bearer"
    expires_in: int  # Seconds until access_token expires


class RefreshTokenRequest(BaseModel):
    """Request to refresh an expired access token."""
    refresh_token: str


class RefreshTokenResponse(BaseModel):
    """Response containing new access token."""
    access_token: str
    token_type: str = "Bearer"
    expires_in: int
