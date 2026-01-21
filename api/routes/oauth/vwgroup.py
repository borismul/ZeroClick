"""
VW Group OAuth routes (Volkswagen, Skoda, SEAT, CUPRA).
"""

import secrets
import hashlib
import base64
import logging
from datetime import datetime, timezone, timedelta
from urllib.parse import quote, unquote

import requests as req
from fastapi import APIRouter, HTTPException, Depends

from models.auth import VWGroupAuthRequest, VWGroupCallbackRequest
from config import VW_GROUP_OAUTH_CONFIG
from auth.dependencies import get_current_user
from database import get_db
from utils.encryption import encrypt_string

router = APIRouter(prefix="/vwgroup/auth", tags=["oauth", "vwgroup"])
logger = logging.getLogger(__name__)


@router.post("/url")
def get_vwgroup_auth_url(request: VWGroupAuthRequest, user_id: str = Depends(get_current_user)):
    """Generate VW Group OAuth authorization URL for webview login."""
    brand = request.brand.lower()
    if brand not in VW_GROUP_OAUTH_CONFIG:
        raise HTTPException(status_code=400, detail=f"Unsupported brand: {brand}")

    config = VW_GROUP_OAUTH_CONFIG[brand]
    db = get_db()

    # Verify car exists
    car_ref = db.collection("users").document(user_id).collection("cars").document(request.car_id)
    if not car_ref.get().exists:
        raise HTTPException(status_code=404, detail="Car not found")

    # Generate state and nonce for security
    state = secrets.token_urlsafe(32)
    nonce = secrets.token_urlsafe(32)

    # Generate PKCE code verifier and challenge
    code_verifier = secrets.token_urlsafe(64)
    code_challenge_bytes = hashlib.sha256(code_verifier.encode()).digest()
    code_challenge = base64.urlsafe_b64encode(code_challenge_bytes).decode().rstrip("=")

    # Store state in Firestore for validation on callback
    car_ref.collection("credentials").document("oauth_state").set({
        "state": state,
        "nonce": nonce,
        "brand": brand,
        "code_verifier": code_verifier,
        "created_at": datetime.now(tz=timezone.utc).isoformat(),
    })

    # Build authorization URL with PKCE
    response_type = config.get("response_type", "code id_token token")

    auth_url = (
        f"https://identity.vwgroup.io/oidc/v1/authorize"
        f"?client_id={quote(config['client_id'])}"
        f"&response_type={quote(response_type)}"
        f"&redirect_uri={quote(config['redirect_uri'])}"
        f"&scope={quote(config['scope'])}"
        f"&state={state}"
        f"&nonce={nonce}"
        f"&code_challenge={code_challenge}"
        f"&code_challenge_method=S256"
        f"&prompt=login"
    )

    logger.info(f"Generated {config['name']} OAuth URL for car {request.car_id}")
    return {"auth_url": auth_url, "state": state, "redirect_uri": config["redirect_uri"]}


@router.post("/callback")
def handle_vwgroup_callback(request: VWGroupCallbackRequest, user_id: str = Depends(get_current_user)):
    """Handle VW Group OAuth callback - extract and store tokens from redirect URL."""
    brand = request.brand.lower()
    if brand not in VW_GROUP_OAUTH_CONFIG:
        raise HTTPException(status_code=400, detail=f"Unsupported brand: {brand}")

    config = VW_GROUP_OAUTH_CONFIG[brand]
    db = get_db()

    car_ref = db.collection("users").document(user_id).collection("cars").document(request.car_id)
    if not car_ref.get().exists:
        raise HTTPException(status_code=404, detail="Car not found")

    # Parse params from URL fragment or query
    redirect_url = request.redirect_url
    params = {}

    if "#" in redirect_url:
        fragment = redirect_url.split("#")[1]
        params = dict(p.split("=", 1) for p in fragment.split("&") if "=" in p)
    elif "?" in redirect_url:
        query = redirect_url.split("?")[1]
        params = dict(p.split("=", 1) for p in query.split("&") if "=" in p)

    # URL decode params
    params = {k: unquote(v) for k, v in params.items()}

    # Get stored state
    state_doc = car_ref.collection("credentials").document("oauth_state").get()
    code_verifier = None
    stored_state = None
    if state_doc.exists:
        state_data = state_doc.to_dict()
        code_verifier = state_data.get("code_verifier")
        stored_state = state_data.get("state")

    # Validate state (CSRF protection) - state parameter MUST be present and match
    if not params.get("state") or not stored_state or stored_state != params["state"]:
        logger.warning(f"OAuth state mismatch for car {request.car_id} - possible CSRF attack")
        raise HTTPException(
            status_code=400,
            detail="Invalid OAuth state parameter"
        )

    # Check if we have tokens (hybrid flow) or just code (auth code flow)
    if "access_token" in params and "id_token" in params:
        access_token = params["access_token"]
        id_token = params["id_token"]
        expires_in = int(params.get("expires_in", 3600))
    elif "code" in params and "id_token" in params:
        id_token = params["id_token"]
        if not code_verifier:
            raise HTTPException(status_code=400, detail="Missing code_verifier for token exchange")

        token_url = "https://identity.vwgroup.io/oidc/v1/token"
        token_data = {
            "grant_type": "authorization_code",
            "client_id": config["client_id"],
            "code": params["code"],
            "redirect_uri": config["redirect_uri"],
            "code_verifier": code_verifier,
        }

        token_resp = req.post(token_url, data=token_data)
        if token_resp.status_code != 200:
            logger.error(f"Token exchange failed: {token_resp.text}")
            raise HTTPException(status_code=400, detail=f"Token exchange failed: {token_resp.text}")

        token_json = token_resp.json()
        access_token = token_json.get("access_token")
        expires_in = token_json.get("expires_in", 3600)

        if not access_token:
            raise HTTPException(status_code=400, detail="No access_token in token response")
    elif "code" in params:
        if not code_verifier:
            raise HTTPException(status_code=400, detail="Missing code_verifier for token exchange")

        # Skoda uses a custom token exchange endpoint
        if brand == "skoda":
            token_url = "https://mysmob.api.connect.skoda-auto.cz/api/v1/authentication/exchange-authorization-code"
            token_params = {"tokenType": "CONNECT"}
            token_json_data = {
                "code": params["code"],
                "redirectUri": config["redirect_uri"],
                "verifier": code_verifier,
            }
            token_resp = req.post(token_url, params=token_params, json=token_json_data)
        else:
            token_url = "https://identity.vwgroup.io/oidc/v1/token"
            token_data = {
                "grant_type": "authorization_code",
                "client_id": config["client_id"],
                "code": params["code"],
                "redirect_uri": config["redirect_uri"],
                "code_verifier": code_verifier,
            }
            token_resp = req.post(token_url, data=token_data)

        if token_resp.status_code != 200:
            logger.error(f"Token exchange failed: {token_resp.text}")
            raise HTTPException(status_code=400, detail=f"Token exchange failed: {token_resp.text}")

        token_json = token_resp.json()
        access_token = token_json.get("access_token") or token_json.get("accessToken")
        id_token = token_json.get("id_token") or token_json.get("idToken")
        expires_in = token_json.get("expires_in", 3600)

        if not access_token:
            raise HTTPException(status_code=400, detail="No access_token in token response")
    else:
        raise HTTPException(status_code=400, detail="No code or tokens in redirect URL")

    # Store tokens with encryption (no plaintext)
    tokens = {
        "brand": brand,
        "access_token_encrypted": encrypt_string(access_token),
        "id_token_encrypted": encrypt_string(id_token) if id_token else None,
        "token_type": params.get("token_type", "bearer"),
        "expires_in": expires_in,
        "expires_at": (datetime.now(tz=timezone.utc) + timedelta(seconds=expires_in)).isoformat(),
        "oauth_completed": True,
        "encryption_version": "kms-v1",
        "updated_at": datetime.now(tz=timezone.utc).isoformat(),
    }

    car_ref.collection("credentials").document("api").set(tokens, merge=True)

    # Clean up state doc
    car_ref.collection("credentials").document("oauth_state").delete()

    logger.info(f"{config['name']} OAuth completed for car {request.car_id}, user {user_id}")

    return {
        "status": "success",
        "brand": brand,
        "message": f"{config['name']} connected successfully",
    }
