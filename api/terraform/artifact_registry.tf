# Artifact Registry is bootstrapped via gcloud in deploy.sh
# This data source references the existing repository

data "google_artifact_registry_repository" "api" {
  location      = var.region
  repository_id = "mileage-api"

  depends_on = [google_project_service.apis]
}
