# Cloud Run Service with OAuth authentication via NextAuth

resource "google_cloud_run_v2_service" "frontend" {
  provider = google-beta

  name         = "mileage-frontend"
  location     = var.region
  ingress      = "INGRESS_TRAFFIC_ALL"
  launch_stage = "BETA"

  template {
    service_account = google_service_account.frontend.email

    containers {
      image = "${var.region}-docker.pkg.dev/${var.project_id}/mileage-frontend/frontend:latest"

      ports {
        container_port = 8080
      }

      env {
        name  = "NEXT_PUBLIC_API_URL"
        value = var.api_url
      }

      env {
        name  = "NEXTAUTH_URL"
        value = "https://${var.domain}"
      }

      env {
        name  = "AUTH_TRUST_HOST"
        value = "true"
      }

      env {
        name = "NEXTAUTH_SECRET"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.nextauth_secret.secret_id
            version = "latest"
          }
        }
      }

      env {
        name = "GOOGLE_CLIENT_ID"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.google_client_id.secret_id
            version = "latest"
          }
        }
      }

      env {
        name = "GOOGLE_CLIENT_SECRET"
        value_source {
          secret_key_ref {
            secret  = google_secret_manager_secret.google_client_secret.secret_id
            version = "latest"
          }
        }
      }

      resources {
        limits = {
          cpu    = "1"
          memory = "256Mi"
        }
        cpu_idle = true
        startup_cpu_boost = true
      }
    }

    scaling {
      min_instance_count = 0
      max_instance_count = 1
    }
  }

  depends_on = [
    data.google_artifact_registry_repository.frontend,
    google_project_service.apis,
    google_secret_manager_secret_version.nextauth_secret,
    google_secret_manager_secret_version.google_client_id,
    google_secret_manager_secret_version.google_client_secret,
  ]
}

# Make Cloud Run service publicly accessible (auth is handled by NextAuth)
resource "google_cloud_run_v2_service_iam_member" "public_access" {
  project  = var.project_id
  location = var.region
  name     = google_cloud_run_v2_service.frontend.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# Domain mapping - requires domain verification first
# Verify at: https://www.google.com/webmasters/verification/
resource "google_cloud_run_domain_mapping" "frontend" {
  location = var.region
  name     = var.domain

  metadata {
    namespace = var.project_id
  }

  spec {
    route_name = google_cloud_run_v2_service.frontend.name
  }

  depends_on = [google_cloud_run_v2_service.frontend]
}
