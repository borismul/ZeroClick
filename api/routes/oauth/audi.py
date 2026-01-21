"""
Audi OAuth routes.
"""

import secrets
import hashlib
import base64
import logging
from datetime import datetime, timezone, timedelta
from urllib.parse import urlparse

import requests as req
from fastapi import APIRouter, HTTPException, Depends

from models.auth import AudiAuthRequest, AudiCallbackRequest
from auth.dependencies import get_current_user
from database import get_db
from utils.encryption import encrypt_string

router = APIRouter(prefix="/audi/auth", tags=["oauth", "audi"])
logger = logging.getLogger(__name__)


@router.post("/url")
def get_audi_auth_url(request: AudiAuthRequest, user_id: str = Depends(get_current_user)):
    """Generate Audi OAuth authorization URL for webview login."""
    db = get_db()

    # Verify car exists
    car_ref = db.collection("users").document(user_id).collection("cars").document(request.car_id)
    if not car_ref.get().exists:
        raise HTTPException(status_code=404, detail="Car not found")

    # Generate PKCE values
    code_verifier = secrets.token_urlsafe(64)[:64]
    code_challenge = base64.urlsafe_b64encode(
        hashlib.sha256(code_verifier.encode()).digest()
    ).decode().rstrip("=")

    # Generate state and nonce for security
    state = secrets.token_urlsafe(32)
    nonce = secrets.token_urlsafe(32)

    # Store state and code_verifier in Firestore for validation on callback
    car_ref.collection("credentials").document("oauth_state").set({
        "state": state,
        "nonce": nonce,
        "code_verifier": code_verifier,
        "created_at": datetime.now(tz=timezone.utc).isoformat(),
    })

    # Build authorization URL with PKCE (authorization code flow)
    client_id = "09b6cbec-cd19-4589-82fd-363dfa8c24da@apps_vw-dilab_com"
    redirect_uri = "myaudi:///"

    auth_url = (
        f"https://identity.vwgroup.io/oidc/v1/authorize"
        f"?client_id={client_id}"
        f"&response_type=code"
        f"&redirect_uri={redirect_uri}"
        f"&scope=openid%20profile%20mbb"
        f"&state={state}"
        f"&nonce={nonce}"
        f"&code_challenge={code_challenge}"
        f"&code_challenge_method=S256"
    )

    return {"auth_url": auth_url, "state": state}


@router.post("/callback")
def handle_audi_callback(request: AudiCallbackRequest, user_id: str = Depends(get_current_user)):
    """Handle Audi OAuth callback - exchange authorization code for tokens using PKCE."""
    from car_providers.audi import AudiAPI
    db = get_db()

    car_ref = db.collection("users").document(user_id).collection("cars").document(request.car_id)
    if not car_ref.get().exists:
        raise HTTPException(status_code=404, detail="Car not found")

    # Parse authorization code from URL
    redirect_url = request.redirect_url
    parsed = urlparse(redirect_url)

    # Code can be in query string or fragment
    if parsed.query:
        params = dict(p.split("=", 1) for p in parsed.query.split("&") if "=" in p)
    elif "#" in redirect_url:
        fragment = redirect_url.split("#")[1]
        params = dict(p.split("=", 1) for p in fragment.split("&") if "=" in p)
    else:
        raise HTTPException(status_code=400, detail="Invalid redirect URL - no code found")

    # Get stored oauth_state with code_verifier
    state_doc = car_ref.collection("credentials").document("oauth_state").get()
    if not state_doc.exists:
        raise HTTPException(status_code=400, detail="OAuth state not found - please start auth flow again")

    oauth_state = state_doc.to_dict()
    code_verifier = oauth_state.get("code_verifier")

    # Validate state (CSRF protection) - state parameter MUST be present and match
    if not params.get("state") or oauth_state.get("state") != params["state"]:
        logger.warning(f"OAuth state mismatch for car {request.car_id} - possible CSRF attack")
        raise HTTPException(
            status_code=400,
            detail="Invalid OAuth state parameter"
        )

    # Check if we have a code (PKCE flow) or tokens (legacy hybrid flow)
    code = params.get("code")

    # Keep plaintext tokens for verification before encrypting
    plaintext_tokens = {}

    if code and code_verifier:
        # PKCE flow: exchange code for tokens
        token_response = req.post(
            AudiAPI.TOKEN_URL,
            data={
                "grant_type": "authorization_code",
                "client_id": AudiAPI.CLIENT_ID,
                "code": code,
                "redirect_uri": AudiAPI.REDIRECT_URI,
                "code_verifier": code_verifier,
            },
            headers={
                "User-Agent": "myAudi-Android/4.31.0 (Android 14; SDK 34)",
                "Accept": "application/json",
                "Content-Type": "application/x-www-form-urlencoded",
            }
        )

        if token_response.status_code != 200:
            logger.error(f"Token exchange failed: {token_response.status_code} {token_response.text[:300]}")
            raise HTTPException(status_code=400, detail=f"Token exchange failed: {token_response.text[:200]}")

        token_data = token_response.json()
        expires_in = int(token_data.get("expires_in", 3600))

        # Keep plaintext for verification
        plaintext_tokens = {
            "access_token": token_data["access_token"],
            "id_token": token_data.get("id_token", ""),
            "refresh_token": token_data.get("refresh_token"),
            "token_type": token_data.get("token_type", "bearer"),
            "expires_in": expires_in,
        }

        # Encrypt sensitive tokens before storage (no plaintext)
        tokens = {
            "brand": "audi",
            "access_token_encrypted": encrypt_string(token_data["access_token"]),
            "id_token_encrypted": encrypt_string(token_data.get("id_token", "")) if token_data.get("id_token") else None,
            "refresh_token_encrypted": encrypt_string(token_data.get("refresh_token")) if token_data.get("refresh_token") else None,
            "token_type": token_data.get("token_type", "bearer"),
            "expires_in": expires_in,
            "expires_at": (datetime.now(tz=timezone.utc) + timedelta(seconds=expires_in)).isoformat(),
            "oauth_completed": True,
            "encryption_version": "kms-v1",
            "updated_at": datetime.now(tz=timezone.utc).isoformat(),
        }
    elif params.get("access_token"):
        # Legacy hybrid flow fallback
        expires_in = int(params.get("expires_in", 3600))

        # Keep plaintext for verification
        plaintext_tokens = {
            "access_token": params["access_token"],
            "id_token": params.get("id_token", ""),
            "token_type": params.get("token_type", "bearer"),
            "expires_in": expires_in,
        }

        tokens = {
            "brand": "audi",
            "access_token_encrypted": encrypt_string(params["access_token"]),
            "id_token_encrypted": encrypt_string(params.get("id_token", "")) if params.get("id_token") else None,
            "token_type": params.get("token_type", "bearer"),
            "expires_in": expires_in,
            "expires_at": (datetime.now(tz=timezone.utc) + timedelta(seconds=expires_in)).isoformat(),
            "oauth_completed": True,
            "encryption_version": "kms-v1",
            "updated_at": datetime.now(tz=timezone.utc).isoformat(),
        }
    else:
        raise HTTPException(status_code=400, detail="No authorization code or tokens found in redirect URL")

    # Store tokens
    car_ref.collection("credentials").document("api").set(tokens, merge=True)

    # Update car brand
    car_ref.update({"brand": "audi"})

    # Clean up state doc
    car_ref.collection("credentials").document("oauth_state").delete()

    logger.info(f"Audi OAuth completed for car {request.car_id}, user {user_id}")

    # Test the tokens by fetching vehicle data
    try:
        from car_providers.audi import AudiAPI, AudiTokens
        import time

        api = AudiAPI.__new__(AudiAPI)
        api._session = req.Session()
        api._session.headers.update({
            "User-Agent": "myAudi-Android/4.31.0 (Android 14; SDK 34)",
            "Accept": "application/json",
        })

        api._tokens = AudiTokens(
            access_token=plaintext_tokens["access_token"],
            id_token=plaintext_tokens.get("id_token", ""),
            token_type=plaintext_tokens.get("token_type", "bearer"),
            expires_in=int(plaintext_tokens.get("expires_in", 3600)),
            expires_at=time.time() + int(plaintext_tokens.get("expires_in", 3600)),
            refresh_token=plaintext_tokens.get("refresh_token"),
        )

        vehicles = api.get_vehicles()
        api.close()

        if vehicles:
            car_ref.collection("credentials").document("api").set({"vin": vehicles[0].vin}, merge=True)
            return {
                "status": "success",
                "vin": vehicles[0].vin,
                "vehicles_found": len(vehicles),
            }
        else:
            return {"status": "success", "vehicles_found": 0}

    except Exception as e:
        logger.error(f"Failed to verify Audi tokens: {e}", exc_info=True)
        return {"status": "success", "warning": "Tokens stored but verification failed"}
