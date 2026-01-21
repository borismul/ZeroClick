# Reference secrets created by frontend terraform
# These are used for Identity Platform OAuth configuration

data "google_secret_manager_secret_version" "google_oauth_client_id" {
  secret = "google-oauth-client-id"
}

data "google_secret_manager_secret_version" "google_oauth_client_secret" {
  secret = "google-oauth-client-secret"
}

# Grant API service account access to OAuth secrets
resource "google_secret_manager_secret_iam_member" "api_oauth_client_id" {
  secret_id = "google-oauth-client-id"
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.api.email}"
}

resource "google_secret_manager_secret_iam_member" "api_oauth_client_secret" {
  secret_id = "google-oauth-client-secret"
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.api.email}"
}

# =============================================================================
# JWT RSA Key Pair for RS256 token signing
# =============================================================================

# Generate RSA private key for JWT signing
resource "tls_private_key" "jwt" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

# Secret for JWT private key (used for signing tokens)
resource "google_secret_manager_secret" "jwt_private_key" {
  secret_id = "jwt-private-key"

  replication {
    auto {}
  }

  depends_on = [google_project_service.apis]
}

resource "google_secret_manager_secret_version" "jwt_private_key" {
  secret      = google_secret_manager_secret.jwt_private_key.id
  secret_data = tls_private_key.jwt.private_key_pem
}

# Secret for JWT public key (used for verifying tokens)
resource "google_secret_manager_secret" "jwt_public_key" {
  secret_id = "jwt-public-key"

  replication {
    auto {}
  }

  depends_on = [google_project_service.apis]
}

resource "google_secret_manager_secret_version" "jwt_public_key" {
  secret      = google_secret_manager_secret.jwt_public_key.id
  secret_data = tls_private_key.jwt.public_key_pem
}

# Grant API service account access to JWT secrets
resource "google_secret_manager_secret_iam_member" "api_jwt_private_key" {
  secret_id = google_secret_manager_secret.jwt_private_key.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.api.email}"
}

resource "google_secret_manager_secret_iam_member" "api_jwt_public_key" {
  secret_id = google_secret_manager_secret.jwt_public_key.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.api.email}"
}

# =============================================================================
# KMS for encrypting sensitive data (Tesla tokens, etc.)
# =============================================================================

# KMS Keyring
resource "google_kms_key_ring" "app_keys" {
  name     = "app-keys"
  location = var.region

  depends_on = [google_project_service.apis]
}

# KMS Key for token encryption
resource "google_kms_crypto_key" "token_encryption" {
  name            = "token-encryption"
  key_ring        = google_kms_key_ring.app_keys.id
  rotation_period = "7776000s" # 90 days

  purpose = "ENCRYPT_DECRYPT"

  version_template {
    algorithm        = "GOOGLE_SYMMETRIC_ENCRYPTION"
    protection_level = "SOFTWARE"
  }

  lifecycle {
    prevent_destroy = true
  }
}

# Grant API service account KMS encrypt/decrypt permissions
resource "google_kms_crypto_key_iam_member" "api_kms_encrypt_decrypt" {
  crypto_key_id = google_kms_crypto_key.token_encryption.id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${google_service_account.api.email}"
}
