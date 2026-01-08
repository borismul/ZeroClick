# Cloud Run Service for API

resource "google_cloud_run_v2_service" "api" {
  name     = "mileage-api"
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"

  template {
    service_account = google_service_account.api.email

    containers {
      image = "${var.region}-docker.pkg.dev/${var.project_id}/mileage-api/api:latest"

      ports {
        container_port = 8080
      }

      env {
        name  = "PROJECT_ID"
        value = var.project_id
      }

      env {
        name  = "MAPS_API_KEY"
        value = var.maps_api_key
      }

      env {
        name  = "CONFIG_HOME_LAT"
        value = var.home_lat
      }

      env {
        name  = "CONFIG_HOME_LON"
        value = var.home_lon
      }

      env {
        name  = "CONFIG_OFFICE_LAT"
        value = var.office_lat
      }

      env {
        name  = "CONFIG_OFFICE_LON"
        value = var.office_lon
      }

      env {
        name  = "CONFIG_START_ODOMETER"
        value = var.start_odometer
      }

      env {
        name  = "CONFIG_SKIP_LAT"
        value = var.skip_lat
      }

      env {
        name  = "CONFIG_SKIP_LON"
        value = var.skip_lon
      }

      env {
        name = "AUDI_USERNAME"
        value_source {
          secret_key_ref {
            secret  = "audi-username"
            version = "latest"
          }
        }
      }

      env {
        name = "AUDI_PASSWORD"
        value_source {
          secret_key_ref {
            secret  = "audi-password"
            version = "latest"
          }
        }
      }

      env {
        name  = "AUTH_ENABLED"
        value = var.auth_enabled
      }

      env {
        name = "GOOGLE_OAUTH_CLIENT_ID"
        value_source {
          secret_key_ref {
            secret  = "google-oauth-client-id"
            version = "latest"
          }
        }
      }

      env {
        name  = "GOOGLE_IOS_CLIENT_ID"
        value = "269285054406-ft7anq4an8h6d4rh8mmnjca8c67uda96.apps.googleusercontent.com"
      }

      env {
        name  = "OPENCHARGEMAP_API_KEY"
        value = var.openchargemap_api_key
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
    google_project_service.apis,
    data.google_artifact_registry_repository.api,
    google_firestore_database.main,
  ]
}

# Public access (webhook needs to be public)
resource "google_cloud_run_v2_service_iam_member" "api_public" {
  project  = var.project_id
  location = var.region
  name     = google_cloud_run_v2_service.api.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}
