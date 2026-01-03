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
