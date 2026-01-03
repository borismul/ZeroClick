# Artifact Registry is bootstrapped via gcloud in deploy.sh
data "google_artifact_registry_repository" "frontend" {
  location      = var.region
  repository_id = "mileage-frontend"
}
