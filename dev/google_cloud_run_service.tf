resource "google_cloud_run_v2_service" "invy_api" {
  name         = "invy-api-${local.env}"
  location     = local.default_region
  launch_stage = "BETA"

  template {
    scaling {
      min_instance_count = 0
      max_instance_count = 10
    }
    containers {
      image = "asia-northeast1-docker.pkg.dev/invy-prod/invy/invy-api:latest"
      env {
        name  = "APP_ENV"
        value = "dev"
      }
      env {
        name  = "GCP_PROJECT_ID"
        value = local.project
      }
      env {
        name  = "GCS_AVATAR_IMAGE_BUCKET_NAME"
        value = google_storage_bucket.avatar_images.name
      }
      env {
        name  = "GCS_CHAT_MESSAGE_IMAGE_BUCKET_NAME"
        value = google_storage_bucket.chat_images.name
      }
      env {
        name  = "ALLOWED_ORIGINS"
        value = "https://invy-app.dev"
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
        value_source {
          secret_key_ref {
            secret  = data.google_secret_manager_secret.invy_db_password.secret_id
            version = "latest"
          }
        }
      }
      env {
        name  = "DB_CONNECTION_NAME"
        value = "/cloudsql/${google_sql_database_instance.invy.connection_name}"
      }
      env {
        name  = "REDIS_URL"
        value = upstash_redis_database.invy.endpoint
      }
      env {
        name  = "REDIS_PASSWORD"
        value = upstash_redis_database.invy.password
      }
      env {
        name  = "REDIS_PORT"
        value = upstash_redis_database.invy.port
      }
      env {
        name  = "FIREBASE_SECRET_KEY_PATH"
        value = "/secrets/firebase/key.firebase.json"
      }
      volume_mounts {
        name       = "cloudsql"
        mount_path = "/cloudsql"
      }
      volume_mounts {
        name       = "firebase"
        mount_path = "/secrets/firebase"
      }
    }

    volumes {
      name = "cloudsql"
      cloud_sql_instance {
        instances = [google_sql_database_instance.invy.connection_name]
      }
    }

    volumes {
      name = "firebase"
      secret {
        secret = data.google_secret_manager_secret.firebase_secret_key.secret_id
        items {
          mode    = 0
          path    = "key.firebase.json"
          version = "latest"
        }
      }
    }

    service_account = google_service_account.invy_api.email
  }

  traffic {
    type    = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
    percent = 100
  }

  lifecycle {
    ignore_changes = [
      template.0.containers.0.image,
      annotations,
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
    route_name = google_cloud_run_v2_service.invy_api.name
  }
}

resource "google_cloud_run_service_iam_member" "all_users_are_run_invoker" {
  project  = local.project
  location = google_cloud_run_v2_service.invy_api.location
  service  = google_cloud_run_v2_service.invy_api.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}

resource "google_cloud_run_service_iam_member" "api_ci_is_run_admin" {
  project  = local.project
  location = google_cloud_run_v2_service.invy_api.location
  service  = google_cloud_run_v2_service.invy_api.name
  role     = "roles/run.admin"
  member   = "serviceAccount:${google_service_account.api_ci.email}"
}
