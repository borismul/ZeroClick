# Security Fix Plan - Detailed Implementation Guide

## Overview

This plan addresses security vulnerabilities discovered in the Zero Click authentication and car API integration, with focus on Tesla token security.

**References:**
- [GCP Secret Manager Best Practices](https://docs.cloud.google.com/secret-manager/docs/best-practices)
- [GCP KMS Encrypt/Decrypt](https://docs.cloud.google.com/kms/docs/encrypt-decrypt)
- [SlowAPI Documentation](https://slowapi.readthedocs.io/)
- [PyJWT Security](https://pyjwt.readthedocs.io/en/stable/algorithms.html)
- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security/get-started)

---

## Required Dependencies

Add to `api/pyproject.toml`:

```toml
dependencies = [
    # ... existing deps ...
    "google-cloud-secret-manager>=2.26.0",  # Secret Manager client
    "google-cloud-kms>=3.7.0",               # KMS encryption
    "slowapi>=0.1.9",                        # Rate limiting
    "PyJWT[crypto]>=2.10.1",                 # JWT with RSA support
    "cryptography>=44.0.0",                  # Required for RS256
]
```

Install with:
```bash
cd api && uv add google-cloud-secret-manager google-cloud-kms slowapi "PyJWT[crypto]" cryptography
```

---

## Phase 1: Critical - JWT & Secrets Management

### 1.1 Fix Weak JWT Secret Generation

**Problem:** JWT secret derived from project ID - anyone with code can forge tokens.

**File:** `api/services/token_service.py:30-44`

**Best Practice (from [SuperTokens](https://supertokens.com/blog/rs256-vs-hs256)):**
> Use RS256 (asymmetric signing) over HS256 (shared secret), especially in distributed systems. It separates concerns: the auth server signs, your apps verify.

**Option A: Strong HS256 Secret (Simpler)**

```bash
# Step 1: Generate secure secret
python -c "import secrets; print(secrets.token_hex(64))"

# Step 2: Create secret in GCP
gcloud secrets create jwt-secret \
  --project=mileage-tracker-482013 \
  --replication-policy="user-managed" \
  --locations="europe-west4"

# Step 3: Add secret version
echo -n "YOUR_GENERATED_SECRET" | gcloud secrets versions add jwt-secret --data-file=-

# Step 4: Grant access to Cloud Run service account
gcloud secrets add-iam-policy-binding jwt-secret \
  --member="serviceAccount:mileage-tracker-482013@appspot.gserviceaccount.com" \
  --role="roles/secretmanager.secretAccessor"
```

**New code for `api/services/token_service.py`:**

```python
import logging
from functools import lru_cache
from google.cloud import secretmanager

logger = logging.getLogger(__name__)

@lru_cache(maxsize=1)
def _get_jwt_secret() -> str:
    """Load JWT secret from Secret Manager (cached)."""
    try:
        client = secretmanager.SecretManagerServiceClient()
        name = "projects/mileage-tracker-482013/secrets/jwt-secret/versions/latest"
        response = client.access_secret_version(request={"name": name})
        return response.payload.data.decode("UTF-8")
    except Exception as e:
        logger.error(f"Failed to load JWT secret from Secret Manager: {e}")
        raise RuntimeError("JWT secret not configured") from e
```

**Option B: RS256 Asymmetric Keys (More Secure)**

```bash
# Step 1: Generate RSA key pair
openssl genrsa -out jwt-private.pem 2048
openssl rsa -in jwt-private.pem -pubout -out jwt-public.pem

# Step 2: Create secrets
gcloud secrets create jwt-private-key --data-file=jwt-private.pem
gcloud secrets create jwt-public-key --data-file=jwt-public.pem

# Step 3: Delete local keys
rm jwt-private.pem jwt-public.pem
```

**New code for RS256:**

```python
import jwt
from functools import lru_cache
from google.cloud import secretmanager

@lru_cache(maxsize=1)
def _get_jwt_keys() -> tuple[str, str]:
    """Load RSA key pair from Secret Manager."""
    client = secretmanager.SecretManagerServiceClient()
    project = "mileage-tracker-482013"

    private_key = client.access_secret_version(
        request={"name": f"projects/{project}/secrets/jwt-private-key/versions/latest"}
    ).payload.data.decode("UTF-8")

    public_key = client.access_secret_version(
        request={"name": f"projects/{project}/secrets/jwt-public-key/versions/latest"}
    ).payload.data.decode("UTF-8")

    return private_key, public_key

def create_access_token(data: dict, expires_delta: timedelta) -> str:
    private_key, _ = _get_jwt_keys()
    payload = {**data, "exp": datetime.utcnow() + expires_delta}
    return jwt.encode(payload, private_key, algorithm="RS256")

def verify_access_token(token: str) -> dict | None:
    _, public_key = _get_jwt_keys()
    try:
        # IMPORTANT: Always specify algorithms explicitly (RFC 8725 §2.1)
        return jwt.decode(token, public_key, algorithms=["RS256"])
    except jwt.InvalidTokenError:
        return None
```

**Recommendation:** Use **Option B (RS256)** for better security - private key never leaves signing service.

---

### 1.2 Move Hardcoded API Keys to Secret Manager

**File:** `api/config.py:166-183`

**Step 1: Create secrets**

```bash
# Renault Gigya API keys (per locale)
gcloud secrets create renault-gigya-key-nl --project=mileage-tracker-482013
echo -n "3_ZSMbhKpLMvjMcFB6NWTO2dj91RCQF1d3sRLHmWGJPGUHeZcCZd-0x-Vb4r_bYeYh" | \
  gcloud secrets versions add renault-gigya-key-nl --data-file=-

# Repeat for other locales: fr, de, etc.

# VW Group OAuth client IDs
gcloud secrets create vwgroup-client-id --project=mileage-tracker-482013
echo -n "YOUR_VW_CLIENT_ID" | gcloud secrets versions add vwgroup-client-id --data-file=-
```

**Step 2: Create secrets helper**

Create `api/utils/secrets.py`:

```python
"""Google Cloud Secret Manager utilities."""

import logging
from functools import lru_cache
from google.cloud import secretmanager

logger = logging.getLogger(__name__)
_client: secretmanager.SecretManagerServiceClient | None = None

def _get_client() -> secretmanager.SecretManagerServiceClient:
    global _client
    if _client is None:
        _client = secretmanager.SecretManagerServiceClient()
    return _client

@lru_cache(maxsize=50)
def get_secret(secret_id: str, project: str = "mileage-tracker-482013") -> str:
    """
    Get secret value from Secret Manager.

    Results are cached to avoid repeated API calls.
    Cache is per-process, so secrets refresh on deploy.
    """
    try:
        client = _get_client()
        name = f"projects/{project}/secrets/{secret_id}/versions/latest"
        response = client.access_secret_version(request={"name": name})
        return response.payload.data.decode("UTF-8")
    except Exception as e:
        logger.error(f"Failed to get secret {secret_id}: {e}")
        raise

def get_secret_or_default(secret_id: str, default: str = "") -> str:
    """Get secret with fallback for local development."""
    try:
        return get_secret(secret_id)
    except Exception:
        logger.warning(f"Using default for secret {secret_id}")
        return default
```

**Step 3: Update `api/config.py`**

```python
from utils.secrets import get_secret

# Replace hardcoded keys with:
def get_renault_gigya_key(locale: str) -> str:
    """Get Renault Gigya API key for locale."""
    secret_id = f"renault-gigya-key-{locale.replace('_', '-').lower()}"
    return get_secret(secret_id)

def get_vwgroup_client_id() -> str:
    """Get VW Group OAuth client ID."""
    return get_secret("vwgroup-client-id")
```

---

### 1.3 Move Google Maps API Key

**File:** `api/terraform/environments/dev.tfvars:7`

**Step 1: Create secret**

```bash
gcloud secrets create maps-api-key --project=mileage-tracker-482013
echo -n "AIzaSyBVw3zU_i3ib5QAZTWsymQWz8ppJEODSRA" | \
  gcloud secrets versions add maps-api-key --data-file=-
```

**Step 2: Update Terraform**

In `api/terraform/main.tf`, add:

```hcl
# Reference secret
data "google_secret_manager_secret_version" "maps_api_key" {
  secret = "maps-api-key"
}

# In Cloud Run service environment:
env {
  name  = "MAPS_API_KEY"
  value_source {
    secret_key_ref {
      secret  = "maps-api-key"
      version = "latest"
    }
  }
}
```

**Step 3: Remove from tfvars**

Delete line 7 from `api/terraform/environments/dev.tfvars`:
```diff
- maps_api_key = "AIzaSyBVw3zU_i3ib5QAZTWsymQWz8ppJEODSRA"
```

---

## Phase 2: High - OAuth & Token Security

### 2.1 Fix OAuth State Validation (CSRF Prevention)

**Problem:** State mismatch only logs warning, doesn't reject request.

**Files:**
- `api/routes/oauth/audi.py:102-103`
- `api/routes/oauth/vwgroup.py` (similar)

**Current (INSECURE):**
```python
if params.get("state") and oauth_state.get("state") != params["state"]:
    logger.warning(f"State mismatch for car {request.car_id}")
    # CONTINUES PROCESSING - BAD!
```

**Fix:**
```python
if params.get("state") and oauth_state.get("state") != params["state"]:
    logger.warning(f"OAuth state mismatch for car {request.car_id} - possible CSRF attack")
    raise HTTPException(
        status_code=400,
        detail="Invalid OAuth state parameter"
    )
```

**Test to add in `api/tests/unit/test_oauth_security.py`:**

```python
import pytest
from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_oauth_state_mismatch_rejected():
    """Verify CSRF protection - state mismatch must reject request."""
    # Setup: create a pending OAuth with known state
    # ...

    # Attack: try callback with different state
    response = client.post(
        "/oauth/cars/test-car/audi/callback",
        json={"callback_url": "https://evil.com/?state=wrong-state&code=abc"}
    )

    assert response.status_code == 400
    assert "state" in response.json()["detail"].lower()
```

---

### 2.2 Remove Token Logging

**File:** `api/auth/dependencies.py:78`

**Current (INSECURE):**
```python
log.info(f"Verifying token: {token[:50]}...")
```

**Fix:**
```python
import hashlib

# For debugging, log only a hash prefix (not the token itself)
token_fingerprint = hashlib.sha256(token.encode()).hexdigest()[:8]
log.debug(f"Verifying token fingerprint: {token_fingerprint}")
```

**Best Practice (from [Vaadata](https://www.vaadata.com/blog/jwt-json-web-token-vulnerabilities-common-attacks-and-security-best-practices/)):**
> Do NOT store sensitive info in the token. Avoid putting PII, passwords, or access secrets in JWTs.

---

### 2.3 Encrypt Tesla Tokens in Firestore (CRITICAL FOR MIHAI)

**Problem:** Tesla OAuth tokens stored as plaintext JSON in Firestore.

**File:** `api/car_providers/tesla.py:42-53`

**Step 1: Create KMS keyring and key**

```bash
# Create keyring (one-time)
gcloud kms keyrings create app-keys \
  --location=europe-west4 \
  --project=mileage-tracker-482013

# Create encryption key
gcloud kms keys create token-encryption \
  --keyring=app-keys \
  --location=europe-west4 \
  --purpose=encryption \
  --rotation-period=90d \
  --next-rotation-time=$(date -v+90d -u +%Y-%m-%dT%H:%M:%SZ) \
  --project=mileage-tracker-482013

# Grant Cloud Run service account access
gcloud kms keys add-iam-policy-binding token-encryption \
  --keyring=app-keys \
  --location=europe-west4 \
  --member="serviceAccount:mileage-tracker-482013@appspot.gserviceaccount.com" \
  --role="roles/cloudkms.cryptoKeyEncrypterDecrypter"
```

**Step 2: Create encryption helper**

Create `api/utils/encryption.py`:

```python
"""
Encryption utilities using Google Cloud KMS.

Best practices from: https://docs.cloud.google.com/kms/docs/encrypt-decrypt
- Use envelope encryption for data > 64KB
- KMS key auto-rotates every 90 days
- All encryption/decryption logged in Cloud Audit Logs
"""

import base64
import logging
from functools import lru_cache

from google.cloud import kms

logger = logging.getLogger(__name__)

# KMS key resource name
KMS_KEY_NAME = (
    "projects/mileage-tracker-482013"
    "/locations/europe-west4"
    "/keyRings/app-keys"
    "/cryptoKeys/token-encryption"
)

@lru_cache(maxsize=1)
def _get_kms_client() -> kms.KeyManagementServiceClient:
    """Get cached KMS client."""
    return kms.KeyManagementServiceClient()


def encrypt_string(plaintext: str) -> str:
    """
    Encrypt a string using Cloud KMS.

    Args:
        plaintext: String to encrypt (max 64KB)

    Returns:
        Base64-encoded ciphertext
    """
    if not plaintext:
        return ""

    client = _get_kms_client()

    # KMS encrypt expects bytes
    plaintext_bytes = plaintext.encode("utf-8")

    # Encrypt
    response = client.encrypt(
        request={
            "name": KMS_KEY_NAME,
            "plaintext": plaintext_bytes,
        }
    )

    # Return as base64 string for easy storage
    return base64.b64encode(response.ciphertext).decode("utf-8")


def decrypt_string(ciphertext_b64: str) -> str:
    """
    Decrypt a base64-encoded ciphertext using Cloud KMS.

    Args:
        ciphertext_b64: Base64-encoded ciphertext from encrypt_string()

    Returns:
        Decrypted plaintext string
    """
    if not ciphertext_b64:
        return ""

    client = _get_kms_client()

    # Decode base64
    ciphertext = base64.b64decode(ciphertext_b64)

    # Decrypt
    response = client.decrypt(
        request={
            "name": KMS_KEY_NAME,
            "ciphertext": ciphertext,
        }
    )

    return response.plaintext.decode("utf-8")


def encrypt_dict(data: dict) -> str:
    """Encrypt a dictionary as JSON string."""
    import json
    return encrypt_string(json.dumps(data))


def decrypt_dict(ciphertext_b64: str) -> dict:
    """Decrypt to dictionary."""
    import json
    plaintext = decrypt_string(ciphertext_b64)
    return json.loads(plaintext) if plaintext else {}
```

**Step 3: Update Tesla provider**

Update `api/car_providers/tesla.py`:

```python
from utils.encryption import encrypt_dict, decrypt_dict

def _save_tokens_to_firestore(self, tokens: dict) -> None:
    """Save encrypted tokens to Firestore."""
    try:
        from google.cloud import firestore
        db = firestore.Client()

        # ENCRYPT before storing
        encrypted_tokens = encrypt_dict(tokens)

        db.collection("cache").document(f"tesla_tokens_{self.email}").set({
            "tokens_encrypted": encrypted_tokens,  # Now encrypted!
            "encryption_version": "kms-v1",        # Track encryption method
            "updated_at": datetime.utcnow().isoformat(),
        })
        logger.info("Saved encrypted Tesla tokens to Firestore")
    except Exception as e:
        logger.warning(f"Could not save tokens to Firestore: {e}")


def _load_tokens_from_firestore(self) -> dict | None:
    """Load and decrypt tokens from Firestore."""
    try:
        from google.cloud import firestore
        db = firestore.Client()
        doc = db.collection("cache").document(f"tesla_tokens_{self.email}").get()

        if doc.exists:
            data = doc.to_dict()

            # Handle encrypted tokens (new format)
            if data and "tokens_encrypted" in data:
                logger.info("Loading encrypted Tesla tokens from Firestore")
                return decrypt_dict(data["tokens_encrypted"])

            # Handle legacy unencrypted tokens (migrate on read)
            if data and "tokens" in data:
                logger.warning("Found unencrypted tokens - migrating to encrypted")
                tokens = json.loads(data["tokens"])
                self._save_tokens_to_firestore(tokens)  # Re-save encrypted
                return tokens

    except Exception as e:
        logger.warning(f"Could not load tokens from Firestore: {e}")
    return None
```

**Step 4: Migration script for existing tokens**

Create `api/scripts/migrate_tesla_tokens.py`:

```python
#!/usr/bin/env python3
"""
One-time migration: encrypt existing Tesla tokens in Firestore.

Run with: python -m scripts.migrate_tesla_tokens
"""

import json
from google.cloud import firestore
from utils.encryption import encrypt_dict

def migrate_tesla_tokens():
    db = firestore.Client()
    cache_ref = db.collection("cache")

    # Find all Tesla token documents
    docs = cache_ref.where("tokens", "!=", None).stream()

    migrated = 0
    for doc in docs:
        if not doc.id.startswith("tesla_tokens_"):
            continue

        data = doc.to_dict()

        # Skip if already encrypted
        if "tokens_encrypted" in data:
            print(f"Skipping {doc.id} - already encrypted")
            continue

        # Encrypt and update
        tokens = json.loads(data["tokens"])
        encrypted = encrypt_dict(tokens)

        doc.reference.update({
            "tokens_encrypted": encrypted,
            "encryption_version": "kms-v1",
            "tokens": firestore.DELETE_FIELD,  # Remove plaintext!
        })

        print(f"Migrated {doc.id}")
        migrated += 1

    print(f"\nMigrated {migrated} documents")

if __name__ == "__main__":
    migrate_tesla_tokens()
```

---

### 2.4 Generic Error Messages

**Problem:** Exception details exposed to clients.

**Files:**
- `api/auth/dependencies.py:92`
- `api/routes/oauth/renault.py:117, 228`
- `api/routes/oauth/audi.py:207`

**Pattern to apply everywhere:**

```python
# BEFORE (insecure)
except Exception as e:
    raise HTTPException(status_code=401, detail=str(e))

# AFTER (secure)
except Exception as e:
    # Log full details internally
    logger.error(f"Authentication failed: {e}", exc_info=True)
    # Return generic message to client
    raise HTTPException(status_code=401, detail="Authentication failed")
```

**Create error response helper in `api/utils/errors.py`:**

```python
"""Secure error handling utilities."""

import logging
from fastapi import HTTPException

logger = logging.getLogger(__name__)

def auth_error(internal_message: str, exception: Exception = None) -> HTTPException:
    """Log detailed error internally, return generic message to client."""
    if exception:
        logger.error(f"{internal_message}: {exception}", exc_info=True)
    else:
        logger.error(internal_message)
    return HTTPException(status_code=401, detail="Authentication failed")

def oauth_error(internal_message: str, exception: Exception = None) -> HTTPException:
    """OAuth-specific error handler."""
    if exception:
        logger.error(f"{internal_message}: {exception}", exc_info=True)
    else:
        logger.error(internal_message)
    return HTTPException(status_code=400, detail="OAuth flow failed")
```

---

## Phase 3: Medium - Access Control & Storage

### 3.1 Add Firestore Security Rules

**Best Practice (from [Firebase Docs](https://firebase.google.com/docs/firestore/security/rules-conditions)):**
> The server client libraries bypass all Cloud Firestore Security Rules and instead authenticate through Google Application Default Credentials.

This means our Python backend (using Admin SDK) bypasses rules. Rules protect against:
- Direct client access (if any)
- Firebase Console access by non-admins
- Accidental exposure

Create `firestore.rules`:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {

    // DENY ALL by default
    match /{document=**} {
      allow read, write: if false;
    }

    // Cache collection - backend only (Admin SDK bypasses rules)
    // This rule blocks Firebase Console/client access
    match /cache/{document} {
      allow read, write: if false;
    }

    // User data - only authenticated owner
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;

      // Cars subcollection
      match /cars/{carId} {
        allow read, write: if request.auth != null && request.auth.uid == userId;

        // Credentials - extra protection
        match /credentials/{credType} {
          allow read: if request.auth != null && request.auth.uid == userId;
          allow write: if false;  // Only backend can write credentials
        }
      }
    }

    // Trips - only owner
    match /trips/{tripId} {
      allow read: if request.auth != null &&
                    resource.data.user_id == request.auth.uid;
      allow create: if request.auth != null &&
                      request.resource.data.user_id == request.auth.uid;
      allow update, delete: if request.auth != null &&
                              resource.data.user_id == request.auth.uid;
    }

    // Locations - only owner
    match /locations/{locationId} {
      allow read, write: if request.auth != null &&
                           resource.data.user_id == request.auth.uid;
    }
  }
}
```

**Deploy:**

```bash
# If using Firebase CLI
firebase deploy --only firestore:rules

# Or via gcloud
gcloud firestore databases update --project=mileage-tracker-482013 \
  --rules-file=firestore.rules
```

---

### 3.2 Webhook Authentication

**Problem:** Webhooks accept `?user=email` without verification.

**Step 1: Add Bearer token requirement**

Update `api/routes/webhooks.py`:

```python
from fastapi import Depends, HTTPException, Header
from auth.dependencies import get_current_user

@router.post("/webhook/start")
async def webhook_start(
    lat: float,
    lng: float,
    user_id: str = Depends(get_current_user),  # Require auth
    device_id: str = None,
):
    """Start trip webhook - requires authentication."""
    # user_id now comes from verified JWT, not query param
    ...
```

**Step 2: Update mobile app**

In `mobile/lib/services/api_service.dart`, add auth header:

```dart
Future<Map<String, dynamic>> startTrip(double lat, double lng, {String? deviceId}) async {
  final token = await _getAuthToken();

  final response = await http.post(
    Uri.parse('$_baseUrl/webhook/start').replace(queryParameters: {
      'lat': lat.toString(),
      'lng': lng.toString(),
      if (deviceId != null) 'device_id': deviceId,
    }),
    headers: {
      'Authorization': 'Bearer $token',  // Add auth header
      'Content-Type': 'application/json',
    },
  );

  return jsonDecode(response.body);
}
```

---

### 3.3 Fix CORS Configuration

**Problem:** `allow_origins=["*"]` with `allow_credentials=True` is dangerous.

**File:** `api/main.py`

**Current (INSECURE):**
```python
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    ...
)
```

**Fix:**
```python
from config import CONFIG

# Get frontend URL from config/environment
ALLOWED_ORIGINS = [
    CONFIG.get("frontend_url", "https://mileage-tracker-frontend-xxxxx.run.app"),
    "http://localhost:3000",  # Local dev only
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=ALLOWED_ORIGINS,
    allow_credentials=True,
    allow_methods=["GET", "POST", "PUT", "PATCH", "DELETE"],
    allow_headers=["Authorization", "Content-Type"],
)
```

---

### 3.4 Rate Limiting on Auth Endpoints

**Best Practice (from [SlowAPI GitHub](https://github.com/laurentS/slowapi)):**
> Store state using in-memory dicts for dev, Redis for prod to handle 10k+ RPS.

**Step 1: Add slowapi to dependencies**

```bash
cd api && uv add slowapi
```

**Step 2: Configure rate limiter**

Update `api/main.py`:

```python
from slowapi import Limiter, _rate_limit_exceeded_handler
from slowapi.util import get_remote_address
from slowapi.errors import RateLimitExceeded

# Initialize limiter
limiter = Limiter(key_func=get_remote_address)
app.state.limiter = limiter
app.add_exception_handler(RateLimitExceeded, _rate_limit_exceeded_handler)
```

**Step 3: Apply to auth endpoints**

In `api/routes/auth.py`:

```python
from fastapi import Request
from main import limiter

@router.post("/auth/token")
@limiter.limit("5/minute")  # Max 5 token requests per minute per IP
async def get_token(request: Request, ...):
    ...

@router.post("/auth/refresh")
@limiter.limit("10/minute")  # Max 10 refresh requests per minute per IP
async def refresh_token(request: Request, ...):
    ...
```

**Note:** For production with multiple Cloud Run instances, use Redis backend:

```python
from slowapi import Limiter
from slowapi.util import get_remote_address
import redis

# Redis for distributed rate limiting
redis_client = redis.from_url("redis://your-redis-host:6379")

limiter = Limiter(
    key_func=get_remote_address,
    storage_uri="redis://your-redis-host:6379",
)
```

---

## Phase 4: Low - Code Quality & Hardening

### 4.1 Specific Exception Handling

**File:** `api/auth/middleware.py:99-105`

**Current:**
```python
except Exception:
    pass
```

**Fix:**
```python
import jwt

try:
    payload = token_service.verify_access_token(token)
    if payload:
        return payload.get("email")
except jwt.ExpiredSignatureError:
    logger.debug("Token expired")
except jwt.InvalidTokenError as e:
    logger.debug(f"Invalid token: {type(e).__name__}")
except Exception as e:
    # Unexpected error - log for investigation
    logger.error(f"Unexpected token verification error: {e}", exc_info=True)
return None
```

---

### 4.2 Token Expiration Check on Watch

**File:** `watch/MileageWatch/MileageWatch/APIClient.swift:63`

**Current:**
```swift
private func getAccessToken() -> String? {
    if let cached = cachedToken, !cached.isEmpty {
        return cached  // No expiration check!
    }
    ...
}
```

**Fix:**
```swift
import Foundation

private func getAccessToken() -> String? {
    if let cached = cachedToken, !cached.isEmpty {
        // Check if token is expired
        if !isTokenExpired(cached) {
            return cached
        }
        // Token expired, clear cache
        cachedToken = nil
    }

    let token = KeychainHelper.shared.getToken()
    if let token = token, !isTokenExpired(token) {
        cachedToken = token
        return token
    }
    return nil
}

private func isTokenExpired(_ token: String) -> Bool {
    // Decode JWT payload (middle part)
    let parts = token.split(separator: ".")
    guard parts.count == 3,
          let payloadData = Data(base64Encoded: String(parts[1])
                                  .padding(toLength: ((String(parts[1]).count + 3) / 4) * 4,
                                          withPad: "=", startingAt: 0)),
          let payload = try? JSONSerialization.jsonObject(with: payloadData) as? [String: Any],
          let exp = payload["exp"] as? TimeInterval else {
        return true  // Can't decode = treat as expired
    }

    // Add 60 second buffer
    return Date().timeIntervalSince1970 > (exp - 60)
}
```

---

## Implementation Checklist

### Phase 1 - Critical (Do First)
- [ ] Generate RS256 key pair and store in Secret Manager
- [ ] Update `token_service.py` to use RS256 from Secret Manager
- [ ] Create `api/utils/secrets.py` helper
- [ ] Move Renault/VW API keys to Secret Manager
- [ ] Move Maps API key to Secret Manager
- [ ] Update Terraform to reference secrets
- [ ] Remove all hardcoded keys from source code
- [ ] **Test:** Verify old tokens rejected, new tokens work

### Phase 2 - High (Same Week)
- [ ] Fix OAuth state validation in `audi.py`
- [ ] Fix OAuth state validation in `vwgroup.py`
- [ ] Add test for state mismatch rejection
- [ ] Remove token content from logs
- [ ] Create KMS key for token encryption
- [ ] Create `api/utils/encryption.py`
- [ ] Update Tesla provider to encrypt tokens
- [ ] Run migration script for existing tokens
- [ ] Replace `str(e)` with generic error messages
- [ ] **Test:** Verify tokens encrypted in Firestore

### Phase 3 - Medium (Same Sprint)
- [ ] Create and deploy `firestore.rules`
- [ ] Add Bearer token to webhook endpoints
- [ ] Update mobile app to send auth header
- [ ] Fix CORS to specific origins
- [ ] Add slowapi rate limiting
- [ ] **Test:** Verify rate limits work

### Phase 4 - Low (Next Sprint)
- [ ] Fix exception handling in middleware
- [ ] Add token expiration check on Watch
- [ ] General code review for similar issues

---

## Rollback Plan

1. **JWT Secret Rotation:**
   - Keep old secret in Secret Manager as `jwt-secret-old`
   - Accept both secrets for 24 hours during transition
   - Remove old secret after all tokens refreshed

2. **Firestore Rules:**
   - Test in Firebase Emulator first
   - Deploy with `firebase deploy --only firestore:rules --project=mileage-tracker-482013`
   - Rollback: `firebase firestore:rules:rollback --project=mileage-tracker-482013`

3. **Webhook Auth:**
   - Feature flag: `REQUIRE_WEBHOOK_AUTH=true`
   - Gradual rollout: enable per-user first

---

## Security Verification Checklist

After implementation, verify:

```bash
# 1. Secrets not in source
git log -p --all -S "AIzaSy" -- "*.py" "*.tfvars"  # Should be empty
git log -p --all -S "3_ZSMb" -- "*.py"  # Should be empty

# 2. Tesla tokens encrypted
gcloud firestore databases export gs://backup-bucket --collection-ids=cache
# Inspect exported data - tokens should be base64 ciphertext

# 3. Rate limiting works
for i in {1..10}; do curl -X POST https://api.example.com/auth/token; done
# Should get 429 after 5 requests

# 4. CORS restricted
curl -H "Origin: https://evil.com" -I https://api.example.com/
# Should NOT have Access-Control-Allow-Origin: https://evil.com

# 5. OAuth state validated
# Manual test: modify state parameter in callback URL
# Should get 400 error
```

---

## Sources

- [GCP Secret Manager Best Practices](https://docs.cloud.google.com/secret-manager/docs/best-practices)
- [GCP Secret Manager Python Client](https://pypi.org/project/google-cloud-secret-manager/) - v2.26.0
- [GCP KMS Encrypt/Decrypt](https://docs.cloud.google.com/kms/docs/encrypt-decrypt)
- [GCP KMS Python Client](https://pypi.org/project/google-cloud-kms/) - v3.7.0
- [SlowAPI Rate Limiting](https://github.com/laurentS/slowapi) - v0.1.9
- [SlowAPI Docs](https://slowapi.readthedocs.io/)
- [PyJWT Documentation](https://pyjwt.readthedocs.io/en/stable/) - v2.10.1
- [RS256 vs HS256](https://supertokens.com/blog/rs256-vs-hs256)
- [JWT Security Best Practices](https://www.vaadata.com/blog/jwt-json-web-token-vulnerabilities-common-attacks-and-security-best-practices/)
- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security/get-started)
- [FastAPI Rate Limiting Guide](https://dev.turmansolutions.ai/2025/07/11/rate-limiting-strategies-in-fastapi-protecting-your-api-from-abuse/)
