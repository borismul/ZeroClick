# Enable required APIs

resource "google_project_service" "apis" {
  for_each = toset([
    "run.googleapis.com",
    "artifactregistry.googleapis.com",
    "firestore.googleapis.com",
    "sheets.googleapis.com",
    "geocoding-backend.googleapis.com",
    "directions-backend.googleapis.com",
    "identitytoolkit.googleapis.com",
    "iam.googleapis.com",
    "secretmanager.googleapis.com",
    "cloudkms.googleapis.com",
  ])

  service            = each.value
  disable_on_destroy = false
}

# Identity Platform config with multiple sign-in methods
resource "google_identity_platform_config" "default" {
  project = var.project_id

  sign_in {
    allow_duplicate_emails = false

    # Email/password authentication
    email {
      enabled           = true
      password_required = true
    }

    # Anonymous sign-in (disabled)
    anonymous {
      enabled = false
    }
  }

  depends_on = [google_project_service.apis]
}

# Google Sign-In provider
resource "google_identity_platform_default_supported_idp_config" "google" {
  project       = var.project_id
  enabled       = true
  idp_id        = "google.com"
  client_id     = data.google_secret_manager_secret_version.google_oauth_client_id.secret_data
  client_secret = data.google_secret_manager_secret_version.google_oauth_client_secret.secret_data

  depends_on = [google_identity_platform_config.default]
}

# Apple Sign-In provider (for iOS) - only if credentials provided
resource "google_identity_platform_default_supported_idp_config" "apple" {
  count         = var.apple_client_id != "" ? 1 : 0
  project       = var.project_id
  enabled       = true
  idp_id        = "apple.com"
  client_id     = var.apple_client_id
  client_secret = var.apple_client_secret

  depends_on = [google_identity_platform_config.default]
}
