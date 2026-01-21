"""Unit tests for token_service.py - JWT and refresh token management.

Tests verify:
- create_tokens() generates valid JWT and refresh tokens
- verify_access_token() validates and decodes JWTs
- refresh_access_token() issues new access tokens
- revoke_refresh_token() and revoke_all_user_tokens()
- Token expiry and hash storage
"""

import pytest
from unittest.mock import patch, MagicMock
from datetime import datetime, timezone
import hashlib
import time

from cryptography.hazmat.primitives import serialization
from cryptography.hazmat.primitives.asymmetric import rsa


# Generate test RSA keys once for all tests
_test_private_key_obj = rsa.generate_private_key(public_exponent=65537, key_size=2048)
TEST_PRIVATE_KEY = _test_private_key_obj.private_bytes(
    encoding=serialization.Encoding.PEM,
    format=serialization.PrivateFormat.PKCS8,
    encryption_algorithm=serialization.NoEncryption(),
).decode("utf-8")
TEST_PUBLIC_KEY = _test_private_key_obj.public_key().public_bytes(
    encoding=serialization.Encoding.PEM,
    format=serialization.PublicFormat.SubjectPublicKeyInfo,
).decode("utf-8")


class TestCreateTokens:
    """Tests for create_tokens JWT and refresh token generation."""

    @pytest.fixture
    def mock_db(self):
        """Mock Firestore for token storage."""
        storage = {}

        mock_collection = MagicMock()

        def mock_add(data):
            doc_id = f"token-{len(storage)}"
            storage[doc_id] = data
            mock_ref = MagicMock()
            mock_ref.id = doc_id
            return None, mock_ref

        mock_collection.add = mock_add

        with patch("services.token_service.get_db") as mock_get_db:
            mock_db = MagicMock()
            mock_db.collection.return_value = mock_collection
            mock_get_db.return_value = mock_db
            yield {"storage": storage, "collection": mock_collection}

    @pytest.fixture
    def mock_jwt_keys(self):
        """Mock JWT keys for consistent testing."""
        with patch("services.token_service._get_jwt_keys") as mock:
            mock.return_value = (TEST_PRIVATE_KEY, TEST_PUBLIC_KEY)
            yield mock

    def test_create_tokens_returns_tuple(self, mock_db, mock_jwt_keys):
        """create_tokens returns (access_token, refresh_token, expires_in)."""
        from services.token_service import token_service

        result = token_service.create_tokens("test@example.com")

        assert isinstance(result, tuple)
        assert len(result) == 3
        access_token, refresh_token, expires_in = result
        assert isinstance(access_token, str)
        assert isinstance(refresh_token, str)
        assert isinstance(expires_in, int)

    def test_create_tokens_jwt_is_valid(self, mock_db, mock_jwt_keys):
        """create_tokens generates a valid JWT."""
        import jwt
        from services.token_service import token_service

        access_token, _, _ = token_service.create_tokens("test@example.com")

        # Decode and verify with RS256
        payload = jwt.decode(access_token, TEST_PUBLIC_KEY, algorithms=["RS256"])
        assert payload["email"] == "test@example.com"
        assert payload["sub"] == "test@example.com"
        assert payload["type"] == "access"

    def test_create_tokens_stores_refresh_hash(self, mock_db, mock_jwt_keys):
        """create_tokens stores hashed refresh token in Firestore."""
        from services.token_service import token_service

        _, refresh_token, _ = token_service.create_tokens("test@example.com")

        # Verify token was stored
        assert len(mock_db["storage"]) == 1
        stored = list(mock_db["storage"].values())[0]
        assert stored["user_email"] == "test@example.com"
        assert "token_hash" in stored
        # Verify it's a hash, not the raw token
        assert stored["token_hash"] != refresh_token
        assert stored["token_hash"] == hashlib.sha256(refresh_token.encode()).hexdigest()

    def test_create_tokens_sets_expiry(self, mock_db, mock_jwt_keys):
        """create_tokens sets correct expiry on refresh token."""
        from services.token_service import token_service, REFRESH_TOKEN_EXPIRE_SECONDS

        _, _, _ = token_service.create_tokens("test@example.com")

        stored = list(mock_db["storage"].values())[0]
        expected_expiry = datetime.now(timezone.utc).timestamp() + REFRESH_TOKEN_EXPIRE_SECONDS
        # Allow 5 second tolerance
        assert abs(stored["expires_at"] - expected_expiry) < 5

    def test_create_tokens_returns_expiry_seconds(self, mock_db, mock_jwt_keys):
        """create_tokens returns correct expiry time in seconds."""
        from services.token_service import token_service, ACCESS_TOKEN_EXPIRE_SECONDS

        _, _, expires_in = token_service.create_tokens("test@example.com")

        assert expires_in == ACCESS_TOKEN_EXPIRE_SECONDS


class TestVerifyAccessToken:
    """Tests for verify_access_token JWT validation."""

    @pytest.fixture
    def mock_jwt_keys(self):
        """Mock JWT keys."""
        with patch("services.token_service._get_jwt_keys") as mock:
            mock.return_value = (TEST_PRIVATE_KEY, TEST_PUBLIC_KEY)
            yield mock

    def test_verify_valid_token(self, mock_jwt_keys):
        """verify_access_token returns payload for valid JWT."""
        import jwt
        from services.token_service import token_service

        # Create a valid token with RS256
        payload = {
            "sub": "test@example.com",
            "email": "test@example.com",
            "type": "access",
            "iat": datetime.now(timezone.utc),
            "exp": datetime.now(timezone.utc).timestamp() + 3600,
        }
        token = jwt.encode(payload, TEST_PRIVATE_KEY, algorithm="RS256")

        result = token_service.verify_access_token(token)

        assert result is not None
        assert result["email"] == "test@example.com"

    def test_verify_expired_token_returns_none(self, mock_jwt_keys):
        """verify_access_token returns None for expired JWT."""
        import jwt
        from services.token_service import token_service

        # Create an expired token
        payload = {
            "sub": "test@example.com",
            "email": "test@example.com",
            "type": "access",
            "iat": datetime.now(timezone.utc),
            "exp": datetime.now(timezone.utc).timestamp() - 100,  # Expired
        }
        token = jwt.encode(payload, TEST_PRIVATE_KEY, algorithm="RS256")

        result = token_service.verify_access_token(token)

        assert result is None

    def test_verify_invalid_signature_returns_none(self, mock_jwt_keys):
        """verify_access_token returns None for wrong signature."""
        import jwt
        from services.token_service import token_service

        # Generate a different private key for wrong signature
        other_key_obj = rsa.generate_private_key(public_exponent=65537, key_size=2048)
        other_private_key = other_key_obj.private_bytes(
            encoding=serialization.Encoding.PEM,
            format=serialization.PrivateFormat.PKCS8,
            encryption_algorithm=serialization.NoEncryption(),
        ).decode("utf-8")

        # Create token with different key
        payload = {
            "sub": "test@example.com",
            "email": "test@example.com",
            "type": "access",
            "iat": datetime.now(timezone.utc),
            "exp": datetime.now(timezone.utc).timestamp() + 3600,
        }
        token = jwt.encode(payload, other_private_key, algorithm="RS256")

        result = token_service.verify_access_token(token)

        assert result is None

    def test_verify_non_access_token_returns_none(self, mock_jwt_keys):
        """verify_access_token returns None if type is not 'access'."""
        import jwt
        from services.token_service import token_service

        # Create token with wrong type
        payload = {
            "sub": "test@example.com",
            "email": "test@example.com",
            "type": "refresh",  # Wrong type
            "iat": datetime.now(timezone.utc),
            "exp": datetime.now(timezone.utc).timestamp() + 3600,
        }
        token = jwt.encode(payload, TEST_PRIVATE_KEY, algorithm="RS256")

        result = token_service.verify_access_token(token)

        assert result is None

    def test_verify_malformed_token_returns_none(self, mock_jwt_keys):
        """verify_access_token returns None for malformed token."""
        from services.token_service import token_service

        result = token_service.verify_access_token("not-a-valid-jwt-token")

        assert result is None


class TestRefreshAccessToken:
    """Tests for refresh_access_token functionality."""

    @pytest.fixture
    def mock_db_with_token(self):
        """Mock Firestore with a stored refresh token."""
        refresh_token = "valid-refresh-token-123"
        token_hash = hashlib.sha256(refresh_token.encode()).hexdigest()

        stored_tokens = [{
            "user_email": "test@example.com",
            "token_hash": token_hash,
            "created_at": datetime.now(timezone.utc).isoformat(),
            "expires_at": datetime.now(timezone.utc).timestamp() + 86400,  # Valid for 24h
        }]

        mock_docs = []
        for i, token_data in enumerate(stored_tokens):
            mock_doc = MagicMock()
            mock_doc.to_dict.return_value = token_data
            mock_doc.reference = MagicMock()
            mock_docs.append(mock_doc)

        mock_query = MagicMock()
        mock_query.limit.return_value = mock_query

        def mock_stream():
            # Filter based on where clause
            return iter(mock_docs)

        mock_query.stream = mock_stream

        mock_collection = MagicMock()
        mock_collection.where.return_value = mock_query

        with patch("services.token_service.get_db") as mock_get_db, \
             patch("services.token_service._get_jwt_keys") as mock_keys:
            mock_db = MagicMock()
            mock_db.collection.return_value = mock_collection
            mock_get_db.return_value = mock_db
            mock_keys.return_value = (TEST_PRIVATE_KEY, TEST_PUBLIC_KEY)

            yield {
                "refresh_token": refresh_token,
                "stored_tokens": stored_tokens,
                "mock_docs": mock_docs,
            }

    def test_refresh_returns_new_access_token(self, mock_db_with_token):
        """refresh_access_token returns new JWT for valid refresh token."""
        from services.token_service import token_service

        result = token_service.refresh_access_token(mock_db_with_token["refresh_token"])

        assert result is not None
        access_token, expires_in = result
        assert isinstance(access_token, str)
        assert isinstance(expires_in, int)

    def test_refresh_invalid_token_returns_none(self, mock_db_with_token):
        """refresh_access_token returns None for invalid refresh token."""
        from services.token_service import token_service

        # Override mock to return empty
        with patch("services.token_service.get_db") as mock_get_db:
            mock_query = MagicMock()
            mock_query.where.return_value.limit.return_value.stream.return_value = iter([])
            mock_db = MagicMock()
            mock_db.collection.return_value = mock_query
            mock_get_db.return_value = mock_db

            result = token_service.refresh_access_token("invalid-token")

        assert result is None

    def test_refresh_expired_token_returns_none(self, mock_db_with_token):
        """refresh_access_token returns None and deletes expired token."""
        from services.token_service import token_service

        # Set token as expired
        mock_db_with_token["stored_tokens"][0]["expires_at"] = (
            datetime.now(timezone.utc).timestamp() - 100
        )
        mock_db_with_token["mock_docs"][0].to_dict.return_value = mock_db_with_token["stored_tokens"][0]

        result = token_service.refresh_access_token(mock_db_with_token["refresh_token"])

        assert result is None
        # Verify delete was called
        mock_db_with_token["mock_docs"][0].reference.delete.assert_called_once()


class TestRevokeTokens:
    """Tests for token revocation."""

    @pytest.fixture
    def mock_db_with_tokens(self):
        """Mock Firestore with multiple tokens for a user."""
        tokens = [
            {
                "user_email": "test@example.com",
                "token_hash": hashlib.sha256("token-1".encode()).hexdigest(),
            },
            {
                "user_email": "test@example.com",
                "token_hash": hashlib.sha256("token-2".encode()).hexdigest(),
            },
            {
                "user_email": "other@example.com",
                "token_hash": hashlib.sha256("token-3".encode()).hexdigest(),
            },
        ]

        mock_docs = []
        for token_data in tokens:
            mock_doc = MagicMock()
            mock_doc.to_dict.return_value = token_data
            mock_doc.reference = MagicMock()
            mock_docs.append(mock_doc)

        mock_query = MagicMock()

        def create_where_query(field, op, value):
            # Filter based on query
            if field == "token_hash":
                filtered = [d for d in mock_docs if d.to_dict()["token_hash"] == value]
            elif field == "user_email":
                filtered = [d for d in mock_docs if d.to_dict()["user_email"] == value]
            else:
                filtered = mock_docs

            result_query = MagicMock()
            result_query.limit.return_value.stream.return_value = iter(filtered[:1])
            result_query.stream.return_value = iter(filtered)
            return result_query

        mock_collection = MagicMock()
        mock_collection.where = create_where_query

        with patch("services.token_service.get_db") as mock_get_db:
            mock_db = MagicMock()
            mock_db.collection.return_value = mock_collection
            mock_get_db.return_value = mock_db

            yield {"mock_docs": mock_docs, "tokens": tokens}

    def test_revoke_single_token(self, mock_db_with_tokens):
        """revoke_refresh_token deletes specific token."""
        from services.token_service import token_service

        result = token_service.revoke_refresh_token("token-1")

        assert result is True
        mock_db_with_tokens["mock_docs"][0].reference.delete.assert_called_once()

    def test_revoke_nonexistent_token(self, mock_db_with_tokens):
        """revoke_refresh_token returns False for nonexistent token."""
        from services.token_service import token_service

        result = token_service.revoke_refresh_token("nonexistent-token")

        assert result is False

    def test_revoke_all_user_tokens(self, mock_db_with_tokens):
        """revoke_all_user_tokens deletes all tokens for user."""
        from services.token_service import token_service

        result = token_service.revoke_all_user_tokens("test@example.com")

        assert result == 2  # Two tokens for test@example.com


class TestHashToken:
    """Tests for _hash_token utility."""

    def test_hash_produces_sha256(self):
        """_hash_token produces SHA256 hex digest."""
        from services.token_service import TokenService

        token = "test-token-value"
        result = TokenService._hash_token(token)

        expected = hashlib.sha256(token.encode()).hexdigest()
        assert result == expected

    def test_hash_is_deterministic(self):
        """_hash_token produces same hash for same input."""
        from services.token_service import TokenService

        token = "test-token"
        hash1 = TokenService._hash_token(token)
        hash2 = TokenService._hash_token(token)

        assert hash1 == hash2

    def test_hash_is_different_for_different_tokens(self):
        """_hash_token produces different hash for different inputs."""
        from services.token_service import TokenService

        hash1 = TokenService._hash_token("token-1")
        hash2 = TokenService._hash_token("token-2")

        assert hash1 != hash2
