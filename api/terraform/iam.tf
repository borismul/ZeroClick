# Service Account for API

resource "google_service_account" "api" {
  account_id   = "mileage-api-sa"
  display_name = "Mileage Tracker API"

  depends_on = [google_project_service.apis]
}

# Firestore access
resource "google_project_iam_member" "api_firestore" {
  project = var.project_id
  role    = "roles/datastore.user"
  member  = "serviceAccount:${google_service_account.api.email}"
}

# Secret Manager access for Audi credentials
resource "google_secret_manager_secret_iam_member" "audi_username" {
  secret_id = "audi-username"
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.api.email}"
}

resource "google_secret_manager_secret_iam_member" "audi_password" {
  secret_id = "audi-password"
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:${google_service_account.api.email}"
}

# Cloud Scheduler control (pause/resume odometer polling)
resource "google_project_iam_member" "api_scheduler" {
  project = var.project_id
  role    = "roles/cloudscheduler.admin"
  member  = "serviceAccount:${google_service_account.api.email}"
}
