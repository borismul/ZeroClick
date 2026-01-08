"""
Audi API client using OAuth2 hybrid flow.

This implementation handles Audi's OAuth2 authentication properly,
including consent page bypassing and token management.
"""

import hashlib
import json
import logging
import re
import secrets
import time
from dataclasses import dataclass
from html.parser import HTMLParser
from typing import Any
from urllib.parse import parse_qs, urljoin, urlparse

import requests

logger = logging.getLogger(__name__)


@dataclass
class AudiTokens:
    """Audi OAuth tokens"""
    access_token: str
    id_token: str
    token_type: str
    expires_in: int
    expires_at: float
    code: str | None = None
    state: str | None = None
    refresh_token: str | None = None

    @property
    def is_expired(self) -> bool:
        return time.time() >= self.expires_at - 60  # 60s buffer

    def to_dict(self) -> dict:
        return {
            "access_token": self.access_token,
            "id_token": self.id_token,
            "token_type": self.token_type,
            "expires_in": self.expires_in,
            "expires_at": self.expires_at,
            "code": self.code,
            "state": self.state,
            "refresh_token": self.refresh_token,
        }

    @classmethod
    def from_dict(cls, data: dict) -> "AudiTokens":
        return cls(
            access_token=data["access_token"],
            id_token=data["id_token"],
            token_type=data.get("token_type", "bearer"),
            expires_in=int(data.get("expires_in", 3600)),
            expires_at=float(data.get("expires_at", time.time() + 3600)),
            code=data.get("code"),
            state=data.get("state"),
            refresh_token=data.get("refresh_token"),
        )


@dataclass
class AudiVehicle:
    """Audi vehicle data"""
    vin: str
    name: str | None = None
    model: str | None = None
    odometer_km: float | None = None
    latitude: float | None = None
    longitude: float | None = None
    is_parked: bool | None = None
    state: str | None = None
    battery_level: float | None = None
    range_km: float | None = None
    is_charging: bool = False
    is_plugged_in: bool = False
    charging_power_kw: float | None = None
    raw_data: dict | None = None


class _EmailFormParser(HTMLParser):
    """Parse the email login form"""
    def __init__(self):
        super().__init__()
        self._inside_form = False
        self.target: str | None = None
        self.data: dict[str, str] = {}

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]):
        attrs_dict = dict(attrs)
        if tag == "form" and attrs_dict.get("id") == "emailPasswordForm":
            self._inside_form = True
            self.target = attrs_dict.get("action")
        elif tag == "input" and self._inside_form:
            name = attrs_dict.get("name")
            value = attrs_dict.get("value", "")
            if name:
                self.data[name] = value or ""

    def handle_endtag(self, tag: str):
        if tag == "form":
            self._inside_form = False


class _CredentialsFormParser(HTMLParser):
    """Parse the password form from JavaScript templateModel"""
    def __init__(self):
        super().__init__()
        self._inside_script = False
        self.target: str | None = None
        self.data: dict[str, Any] = {}

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]):
        if tag == "script":
            self._inside_script = True

    def handle_endtag(self, tag: str):
        if tag == "script":
            self._inside_script = False

    def handle_data(self, data: str):
        if not self._inside_script:
            return

        match = re.search(r"templateModel: (.*?),\n", data)
        if match:
            try:
                model = json.loads(match.group(1))
                self.target = model.get("postAction")
                self.data = {
                    "relayState": model.get("relayState"),
                    "hmac": model.get("hmac"),
                }
            except json.JSONDecodeError:
                pass

        csrf_match = re.search(r"csrf_token: '([^']+)'", data)
        if csrf_match:
            self.data["_csrf"] = csrf_match.group(1)


def _generate_pkce() -> tuple[str, str]:
    """Generate PKCE code verifier and challenge."""
    import base64
    code_verifier = secrets.token_urlsafe(64)[:64]
    code_challenge = base64.urlsafe_b64encode(
        hashlib.sha256(code_verifier.encode()).digest()
    ).decode().rstrip("=")
    return code_verifier, code_challenge


class AudiAPI:
    """
    Audi Connect API client.

    Uses OAuth2 authorization code flow with PKCE to authenticate and fetch vehicle data.
    """

    CLIENT_ID = "09b6cbec-cd19-4589-82fd-363dfa8c24da@apps_vw-dilab_com"
    REDIRECT_URI = "myaudi:///"
    CARIAD_URL = "https://emea.bff.cariad.digital"
    AUTH_URL = "https://identity.vwgroup.io/oidc/v1/authorize"
    TOKEN_URL = "https://emea.bff.cariad.digital/login/v1/idk/token"  # Cariad BFF token endpoint
    IDENTITY_URL = "https://identity.vwgroup.io"

    # API endpoints
    VEHICLE_API = "https://emea.bff.cariad.digital/vehicle/v1/vehicles"
    USER_API = "https://emea.bff.cariad.digital/user-login/v1/user"

    # Required headers for Cariad BFF API
    API_HEADERS = {
        "User-Agent": "myAudi-Android/4.31.0 (Android 14; Build/UKQ1.231003.002)",
        "X-App-Version": "4.31.0",
        "X-App-Name": "myAudi",
    }

    def __init__(self, username: str, password: str, country: str = "NL"):
        self.username = username
        self.password = password
        self.country = country
        self._session = requests.Session()
        self._session.headers.update({
            "User-Agent": "myAudi-Android/4.31.0 (Android 14; SDK 34)",
            "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
            "Accept-Language": f"en-{country}, en; q=0.9",
            "Accept-Encoding": "gzip, deflate",
        })
        self._tokens: AudiTokens | None = None

    @property
    def tokens(self) -> AudiTokens | None:
        return self._tokens

    @tokens.setter
    def tokens(self, value: AudiTokens | None):
        self._tokens = value

    def login(self) -> AudiTokens:
        """
        Perform OAuth2 authorization code flow with PKCE.

        Returns tokens from the Cariad BFF token endpoint.
        """
        logger.info(f"Starting Audi login for {self.username}")

        # Generate PKCE values
        code_verifier, code_challenge = _generate_pkce()

        # Step 1: Get login form with PKCE params
        params = {
            "client_id": self.CLIENT_ID,
            "response_type": "code",  # Authorization code flow
            "redirect_uri": self.REDIRECT_URI,
            "scope": "openid profile mbb",
            "state": secrets.token_urlsafe(16),
            "nonce": secrets.token_urlsafe(16),
            "code_challenge": code_challenge,
            "code_challenge_method": "S256",
        }

        response = self._session.get(self.AUTH_URL, params=params, allow_redirects=True)
        response.raise_for_status()

        email_form = _EmailFormParser()
        email_form.feed(response.text)

        if not email_form.target or not all(k in email_form.data for k in ["_csrf", "relayState", "hmac"]):
            raise AuthenticationError("Could not find email login form")

        # Step 2: Submit email
        email_form.data["email"] = self.username
        email_url = urljoin(self.IDENTITY_URL, email_form.target)

        response = self._session.post(email_url, data=email_form.data, allow_redirects=True)
        response.raise_for_status()

        # Step 3: Parse and submit password
        creds_form = _CredentialsFormParser()
        creds_form.feed(response.text)

        if not creds_form.target or "_csrf" not in creds_form.data:
            raise AuthenticationError("Could not find password form")

        creds_form.data["email"] = self.username
        creds_form.data["password"] = self.password

        password_url = f"{self.IDENTITY_URL}/signin-service/v1/{self.CLIENT_ID}/{creds_form.target}"
        response = self._session.post(password_url, data=creds_form.data, allow_redirects=False)

        if response.status_code not in (302, 303):
            raise AuthenticationError(f"Login failed with status {response.status_code}")

        # Step 4: Follow redirects until we get myaudi://
        url = response.headers.get("Location", "")

        for _ in range(20):
            if not url:
                raise AuthenticationError("Empty redirect URL")
            if url.startswith("myaudi://"):
                break

            full_url = url if url.startswith("http") else urljoin(self.IDENTITY_URL, url)
            response = self._session.get(full_url, allow_redirects=False)

            if response.status_code in (302, 303):
                url = response.headers.get("Location", "")
            elif response.status_code == 200:
                # Check for myaudi:// in response body (JS redirect)
                match = re.search(r'(myaudi://[^"\'<>\s]+)', response.text)
                if match:
                    url = match.group(1)
                    break
                raise AuthenticationError("No redirect URL in response body")
            else:
                raise AuthenticationError(f"Unexpected status {response.status_code}")

        if not url.startswith("myaudi://"):
            raise AuthenticationError("Did not receive redirect to myaudi://")

        # Step 5: Parse authorization code from URL query string (PKCE flow)
        parsed = urlparse(url)
        query_params = parse_qs(parsed.query)
        code = query_params.get("code", [None])[0]

        if not code:
            raise AuthenticationError("No authorization code in redirect URL")

        # Step 6: Exchange code for tokens using PKCE
        token_data = {
            "grant_type": "authorization_code",
            "client_id": self.CLIENT_ID,
            "code": code,
            "redirect_uri": self.REDIRECT_URI,
            "code_verifier": code_verifier,
        }

        response = self._session.post(self.TOKEN_URL, data=token_data)
        if response.status_code != 200:
            raise AuthenticationError(f"Token exchange failed: {response.status_code} {response.text[:200]}")

        tokens = response.json()
        expires_in = int(tokens.get("expires_in", 3600))
        self._tokens = AudiTokens(
            access_token=tokens["access_token"],
            id_token=tokens.get("id_token", ""),
            token_type=tokens.get("token_type", "bearer"),
            expires_in=expires_in,
            expires_at=time.time() + expires_in,
            code=code,
            refresh_token=tokens.get("refresh_token"),
        )

        logger.info("Audi login successful")
        return self._tokens

    def _exchange_code_for_refresh_token(self, code: str, code_verifier: str = None):
        """Exchange authorization code for refresh token (legacy, now integrated in login)."""
        data = {
            "grant_type": "authorization_code",
            "client_id": self.CLIENT_ID,
            "code": code,
            "redirect_uri": self.REDIRECT_URI,
        }
        if code_verifier:
            data["code_verifier"] = code_verifier

        response = self._session.post(self.TOKEN_URL, data=data)
        if response.status_code != 200:
            logger.warning(f"Token exchange failed: {response.status_code} {response.text[:200]}")
            return

        token_data = response.json()
        if "refresh_token" in token_data:
            self._tokens.refresh_token = token_data["refresh_token"]
            logger.info("Got refresh token from code exchange")

            # Also update access/id tokens if returned
            if "access_token" in token_data:
                self._tokens.access_token = token_data["access_token"]
            if "id_token" in token_data:
                self._tokens.id_token = token_data["id_token"]
            if "expires_in" in token_data:
                self._tokens.expires_in = int(token_data["expires_in"])
                self._tokens.expires_at = time.time() + self._tokens.expires_in

    def refresh(self) -> bool:
        """Refresh access token using refresh token."""
        if not self._tokens or not self._tokens.refresh_token:
            logger.info("No refresh token available")
            return False

        logger.info("Refreshing Audi access token")
        data = {
            "grant_type": "refresh_token",
            "client_id": self.CLIENT_ID,
            "refresh_token": self._tokens.refresh_token,
        }

        try:
            response = self._session.post(self.TOKEN_URL, data=data)
            if response.status_code != 200:
                logger.warning(f"Token refresh failed: {response.status_code} {response.text[:200]}")
                return False

            token_data = response.json()

            self._tokens.access_token = token_data["access_token"]
            self._tokens.id_token = token_data.get("id_token", self._tokens.id_token)
            self._tokens.expires_in = int(token_data.get("expires_in", 3600))
            self._tokens.expires_at = time.time() + self._tokens.expires_in

            # Update refresh token if a new one is issued
            if "refresh_token" in token_data:
                self._tokens.refresh_token = token_data["refresh_token"]

            logger.info("Audi token refresh successful")
            return True

        except Exception as e:
            logger.error(f"Token refresh error: {e}")
            return False

    def _ensure_tokens(self):
        """Ensure we have valid tokens, refreshing or logging in if needed."""
        if self._tokens is None:
            self.login()
        elif self._tokens.is_expired:
            # Try refresh first, fall back to full login
            if not self.refresh():
                logger.info("Refresh failed, doing full login")
                self.login()

    def _api_request(self, method: str, url: str, **kwargs) -> requests.Response:
        """Make an authenticated API request."""
        self._ensure_tokens()

        headers = kwargs.pop("headers", {})
        headers["Authorization"] = f"Bearer {self._tokens.access_token}"
        headers["Accept"] = "application/json"
        headers.update(self.API_HEADERS)

        response = self._session.request(method, url, headers=headers, **kwargs)

        # Retry once on 401
        if response.status_code == 401:
            logger.warning("Got 401, re-authenticating...")
            self.login()
            headers["Authorization"] = f"Bearer {self._tokens.access_token}"
            response = self._session.request(method, url, headers=headers, **kwargs)

        return response

    def get_vehicles(self) -> list[AudiVehicle]:
        """Fetch list of vehicles."""
        self._ensure_tokens()

        # Get vehicle list from BFF API
        response = self._api_request("GET", self.VEHICLE_API)

        if response.status_code != 200:
            logger.error(f"Failed to get vehicles: {response.status_code} {response.text[:200]}")
            return []

        data = response.json()
        vehicles = []

        for v in data.get("data", []):
            vin = v.get("vin", "")
            vehicle = AudiVehicle(
                vin=vin,
                name=v.get("nickname") or v.get("model", {}).get("name"),
                model=v.get("model", {}).get("name"),
                raw_data=v,
            )
            vehicles.append(vehicle)

        return vehicles

    def get_vehicle_status(self, vin: str) -> AudiVehicle | None:
        """Fetch detailed status for a vehicle using selectivestatus endpoint."""
        self._ensure_tokens()

        vehicle = AudiVehicle(vin=vin)
        base_url = f"{self.VEHICLE_API}/{vin}/selectivestatus"

        # Fetch data using specific jobs that work
        jobs_to_fetch = [
            "measurements",  # odometer, range
            "fuelStatus",    # battery SOC, range
            "charging",      # charging status
            "readiness",     # online status
        ]

        raw_data = {}

        for job in jobs_to_fetch:
            try:
                response = self._api_request("GET", base_url, params={"jobs": job})
                if response.status_code in (200, 207):
                    data = response.json()
                    if data:
                        raw_data[job] = data
                        self._parse_job_data(vehicle, job, data)
            except Exception as e:
                logger.warning(f"Failed to fetch {job} for {vin}: {e}")

        # Fetch parking position separately (different endpoint)
        try:
            park_url = f"{self.VEHICLE_API}/{vin}/parkingposition"
            response = self._api_request("GET", park_url)
            if response.status_code == 200:
                data = response.json()
                raw_data["parkingPosition"] = data
                if "data" in data:
                    vehicle.latitude = data["data"].get("lat")
                    vehicle.longitude = data["data"].get("lon")
        except Exception as e:
            logger.warning(f"Failed to fetch parking position for {vin}: {e}")

        vehicle.raw_data = raw_data
        return vehicle

    def _parse_job_data(self, vehicle: AudiVehicle, job: str, data: dict):
        """Parse data from a specific selectivestatus job."""
        try:
            if job == "measurements":
                m = data.get("measurements", {})
                # Odometer
                odo_status = m.get("odometerStatus", {}).get("value", {})
                if "odometer" in odo_status:
                    vehicle.odometer_km = float(odo_status["odometer"])
                # Range
                range_status = m.get("rangeStatus", {}).get("value", {})
                if "electricRange" in range_status:
                    vehicle.range_km = float(range_status["electricRange"])
                elif "totalRange_km" in range_status:
                    vehicle.range_km = float(range_status["totalRange_km"])

            elif job == "fuelStatus":
                fs = data.get("fuelStatus", {})
                range_status = fs.get("rangeStatus", {}).get("value", {})
                primary = range_status.get("primaryEngine", {})
                if "currentSOC_pct" in primary:
                    vehicle.battery_level = float(primary["currentSOC_pct"])
                if "remainingRange_km" in primary:
                    vehicle.range_km = float(primary["remainingRange_km"])

            elif job == "charging":
                ch = data.get("charging", {})
                # Battery status
                bat_status = ch.get("batteryStatus", {}).get("value", {})
                if "currentSOC_pct" in bat_status:
                    vehicle.battery_level = float(bat_status["currentSOC_pct"])
                if "cruisingRangeElectric_km" in bat_status:
                    vehicle.range_km = float(bat_status["cruisingRangeElectric_km"])
                # Charging status
                charge_status = ch.get("chargingStatus", {}).get("value", {})
                if "chargingState" in charge_status:
                    state = charge_status["chargingState"]
                    vehicle.is_charging = state == "charging"
                if "chargePower_kW" in charge_status:
                    vehicle.charging_power_kw = float(charge_status["chargePower_kW"])
                # Plug status
                plug_status = ch.get("plugStatus", {}).get("value", {})
                if "plugConnectionState" in plug_status:
                    vehicle.is_plugged_in = plug_status["plugConnectionState"] == "connected"

            elif job == "readiness":
                rd = data.get("readiness", {})
                ready_status = rd.get("readinessStatus", {}).get("value", {})
                conn = ready_status.get("connectionState", {})
                if "isActive" in conn:
                    # isActive=false means parked, isActive=true means driving
                    vehicle.is_parked = not conn["isActive"]
                    vehicle.state = "parked" if vehicle.is_parked else "driving"

        except Exception as e:
            logger.warning(f"Error parsing {job} data: {e}")

    def close(self):
        """Close the session."""
        self._session.close()


class AuthenticationError(Exception):
    """Authentication failed."""
    pass


# Provider class that matches the CarProvider interface
from .base import CarProvider, CarData, VehicleState


class AudiProvider(CarProvider):
    """
    Audi Connect provider using the new AudiAPI.

    This provider wraps AudiAPI to match the CarProvider interface
    used by the rest of the application.

    Supports two authentication modes:
    1. Username/password login (legacy, still works)
    2. Pre-stored OAuth tokens (from webview login flow)
    """

    def __init__(
        self,
        username: str = None,
        password: str = None,
        country: str = "NL",
        vin: str = None,
        # OAuth token support
        access_token: str = None,
        id_token: str = None,
        token_type: str = "bearer",
        expires_at: float = None,
        refresh_token: str = None,
        **kwargs
    ):
        self._username = username
        self._password = password
        self._country = country
        self._vin = vin
        self._api: AudiAPI | None = None
        self._connected = False

        # Store pre-provided tokens
        self._access_token = access_token
        self._id_token = id_token
        self._token_type = token_type
        self._expires_at = expires_at
        self._refresh_token = refresh_token

    @property
    def brand(self) -> str:
        return "audi"

    def connect(self) -> bool:
        """Connect to Audi API using tokens or username/password."""
        try:
            # If we have pre-stored tokens, use them
            if self._access_token and self._id_token:
                import time
                self._api = AudiAPI.__new__(AudiAPI)
                self._api.username = self._username
                self._api.password = self._password
                self._api.country = self._country
                self._api._session = __import__("requests").Session()
                self._api._session.headers.update({
                    "User-Agent": "myAudi-Android/4.31.0 (Android 14; SDK 34)",
                    "Accept": "application/json",
                })

                # Check if tokens are expired
                expires_at = self._expires_at or (time.time() + 3600)
                if time.time() >= expires_at - 60:
                    # Tokens expired - try refresh first
                    if self._refresh_token:
                        logger.info("Stored tokens expired, trying refresh")
                        self._api._tokens = AudiTokens(
                            access_token=self._access_token,
                            id_token=self._id_token,
                            token_type=self._token_type,
                            expires_in=0,
                            expires_at=0,
                            refresh_token=self._refresh_token,
                        )
                        if self._api.refresh():
                            self._connected = True
                            logger.info("Token refresh successful")
                            return True
                        logger.warning("Refresh failed, falling back to login")
                    else:
                        logger.info("Stored tokens expired, no refresh token available")
                    return self._login_with_credentials()

                self._api._tokens = AudiTokens(
                    access_token=self._access_token,
                    id_token=self._id_token,
                    token_type=self._token_type,
                    expires_in=int(expires_at - time.time()),
                    expires_at=expires_at,
                    refresh_token=self._refresh_token,
                )
                self._connected = True
                logger.info("Using stored Audi OAuth tokens")
                return True

            # Fall back to username/password login
            return self._login_with_credentials()

        except Exception as e:
            logger.error(f"Failed to connect to Audi API: {e}")
            self._connected = False
            return False

    def _login_with_credentials(self) -> bool:
        """Login using username and password."""
        if not self._username or not self._password:
            logger.error("No username/password provided and no valid tokens")
            return False

        self._api = AudiAPI(
            username=self._username,
            password=self._password,
            country=self._country,
        )
        self._api.login()
        self._connected = True
        return True

    def get_data(self) -> CarData:
        """Fetch car data from Audi API."""
        if not self._api:
            if not self.connect():
                return CarData()

        try:
            # Get vehicles if we don't have a VIN
            vin = self._vin
            if not vin:
                vehicles = self._api.get_vehicles()
                if vehicles:
                    vin = vehicles[0].vin
                else:
                    logger.error("No vehicles found")
                    return CarData()

            # Get vehicle status
            status = self._api.get_vehicle_status(vin)
            if not status:
                return CarData(vin=vin)

            # Convert to CarData
            state = VehicleState.UNKNOWN
            if status.is_parked is not None:
                state = VehicleState.PARKED if status.is_parked else VehicleState.DRIVING
            if status.is_charging:
                state = VehicleState.CHARGING

            return CarData(
                vin=status.vin,
                odometer_km=status.odometer_km,
                latitude=status.latitude,
                longitude=status.longitude,
                state=state,
                battery_level=status.battery_level,
                range_km=status.range_km,
                is_charging=status.is_charging,
                is_plugged_in=status.is_plugged_in,
                charging_power_kw=status.charging_power_kw,
                raw_data=status.raw_data,
            )

        except Exception as e:
            logger.error(f"Failed to get Audi data: {e}")
            import traceback
            logger.error(traceback.format_exc())
            return CarData()

    def get_tokens(self) -> dict | None:
        """Get current tokens for saving to storage."""
        if self._api and self._api.tokens:
            return self._api.tokens.to_dict()
        return None

    def disconnect(self) -> None:
        """Close the Audi API connection."""
        if self._api:
            self._api.close()
            self._api = None
        self._connected = False
