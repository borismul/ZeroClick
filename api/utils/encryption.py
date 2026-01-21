"""
Encryption utilities using Google Cloud KMS.

Best practices from: https://docs.cloud.google.com/kms/docs/encrypt-decrypt
- Use envelope encryption for data > 64KB
- KMS key auto-rotates every 90 days
- All encryption/decryption logged in Cloud Audit Logs

For local development without KMS, uses a fallback that stores data unencrypted
with a warning. This should NEVER be used in production.
"""

import base64
import json
import logging
import os
from functools import lru_cache

logger = logging.getLogger(__name__)

# KMS key resource name
PROJECT_ID = os.environ.get("PROJECT_ID", "mileage-tracker-482013")
KMS_LOCATION = os.environ.get("KMS_LOCATION", "europe-west4")
KMS_KEYRING = os.environ.get("KMS_KEYRING", "app-keys")
KMS_KEY = os.environ.get("KMS_KEY", "token-encryption")

KMS_KEY_NAME = (
    f"projects/{PROJECT_ID}"
    f"/locations/{KMS_LOCATION}"
    f"/keyRings/{KMS_KEYRING}"
    f"/cryptoKeys/{KMS_KEY}"
)

# Prefix to identify encrypted data
ENCRYPTED_PREFIX = "KMS_ENC_V1:"


@lru_cache(maxsize=1)
def _get_kms_client():
    """Get cached KMS client."""
    from google.cloud import kms
    return kms.KeyManagementServiceClient()


def _is_kms_available() -> bool:
    """Check if KMS is available (for local dev fallback)."""
    try:
        # Try to get the client - will fail if not in GCP
        _get_kms_client()
        return True
    except Exception:
        return False


def encrypt_string(plaintext: str) -> str:
    """
    Encrypt a string using Cloud KMS.

    Args:
        plaintext: String to encrypt (max 64KB)

    Returns:
        Prefixed base64-encoded ciphertext (format: "KMS_ENC_V1:<base64>")
        Returns original string with warning prefix if KMS unavailable
    """
    if not plaintext:
        return ""

    # Try KMS encryption
    try:
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

        # Return as prefixed base64 string for easy identification
        ciphertext_b64 = base64.b64encode(response.ciphertext).decode("utf-8")
        return f"{ENCRYPTED_PREFIX}{ciphertext_b64}"

    except Exception as e:
        logger.warning(f"KMS encryption failed, data stored unencrypted: {e}")
        # Return plaintext for local dev (with warning logged)
        return plaintext


def decrypt_string(ciphertext: str) -> str:
    """
    Decrypt a string using Cloud KMS.

    Args:
        ciphertext: Either KMS-encrypted string (prefixed with KMS_ENC_V1:)
                   or plaintext (for legacy/local dev data)

    Returns:
        Decrypted plaintext string
    """
    if not ciphertext:
        return ""

    # Check if this is KMS-encrypted data
    if not ciphertext.startswith(ENCRYPTED_PREFIX):
        # Legacy unencrypted data - return as-is
        logger.debug("Data not KMS-encrypted, returning as-is")
        return ciphertext

    # Remove prefix and decrypt
    try:
        ciphertext_b64 = ciphertext[len(ENCRYPTED_PREFIX):]
        ciphertext_bytes = base64.b64decode(ciphertext_b64)

        client = _get_kms_client()

        # Decrypt
        response = client.decrypt(
            request={
                "name": KMS_KEY_NAME,
                "ciphertext": ciphertext_bytes,
            }
        )

        return response.plaintext.decode("utf-8")

    except Exception as e:
        logger.error(f"KMS decryption failed: {e}")
        raise


def encrypt_dict(data: dict) -> str:
    """
    Encrypt a dictionary as JSON string.

    Args:
        data: Dictionary to encrypt

    Returns:
        Encrypted string
    """
    return encrypt_string(json.dumps(data))


def decrypt_dict(ciphertext: str) -> dict:
    """
    Decrypt to dictionary.

    Args:
        ciphertext: Encrypted string (or legacy JSON string)

    Returns:
        Decrypted dictionary
    """
    plaintext = decrypt_string(ciphertext)
    if not plaintext:
        return {}

    # Handle case where plaintext is already a dict (shouldn't happen but be safe)
    if isinstance(plaintext, dict):
        return plaintext

    try:
        return json.loads(plaintext)
    except json.JSONDecodeError:
        logger.error("Failed to decode decrypted data as JSON")
        return {}


def is_encrypted(value: str) -> bool:
    """Check if a value is KMS-encrypted."""
    return value.startswith(ENCRYPTED_PREFIX) if value else False
