
resource "google_cloud_run_service" "invy_api" {
  name     = "invy-api-${local.env}"
  location = local.default_region
  template {
    spec {
      containers {
        image = "asia-northeast1-docker.pkg.dev/invy-prod/invy/invy-api:latest"
        env {
          name  = "APP_ENV"
          value = "prod"
        }
        env {
          name  = "GCP_PROJECT_ID"
          value = local.project
        }
        env {
          name  = "ALLOWED_ORIGINS"
          value = "https://invy-app.com"
        }
        env {
          name  = "DB_NAME"
          value = google_sql_database.invy.name
        }
        env {
          name  = "DB_USER"
          value = google_sql_user.postgres.name
        }
        env {
          name = "DB_PASSWORD"
          value_from {
            secret_key_ref {
              name = data.google_secret_manager_secret.invy_db_password.secret_id
              key  = "latest"
            }
          }
        }
        env {
          name  = "DB_CONNECTION_NAME"
          value = "/cloudsql/${google_sql_database_instance.invy.connection_name}"
        }
        env {
          name  = "FIREBASE_SECRET_KEY_PATH"
          value = "/secrets/firebase/key.firebase.json"
        }
        volume_mounts {
          name       = "firebase"
          mount_path = "/secrets/firebase"
        }
      }
      volumes {
        name = "firebase"
        secret {
          secret_name = data.google_secret_manager_secret.firebase_secret_key.secret_id
          items {
            key  = "latest"
            path = "key.firebase.json"
          }
        }
      }

      service_account_name = google_service_account.invy_api.email
    }
    metadata {
      annotations = {
        "run.googleapis.com/launch-stage"       = "BETA"
        "run.googleapis.com/cloudsql-instances" = google_sql_database_instance.invy.connection_name
        "autoscaling.knative.dev/minScale"      = "0"
        "autoscaling.knative.dev/maxScale"      = "10"
      }
    }
  }
  traffic {
    percent         = 100
    latest_revision = true
  }

  autogenerate_revision_name = true

  lifecycle {
    ignore_changes = [
      metadata.0.annotations,
      template.0.spec.0.containers.0.image,
      template.0.metadata.0.annotations,
    ]
  }
}

resource "google_cloud_run_domain_mapping" "invy_api" {
  location = local.default_region
  name     = "api.${local.root_domain}"

  metadata {
    namespace = local.project
  }

  spec {
    route_name = google_cloud_run_service.invy_api.name
  }
}

data "google_iam_policy" "no_auth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "invy_api_no_auth" {
  location = google_cloud_run_service.invy_api.location
  project  = google_cloud_run_service.invy_api.project
  service  = google_cloud_run_service.invy_api.name

  policy_data = data.google_iam_policy.no_auth.policy_data
}

resource "google_project_iam_member" "api_ci_is_run_admin" {
  project = local.project
  role    = "roles/run.admin"
  member  = "serviceAccount:${google_service_account.api_ci.email}"
}
