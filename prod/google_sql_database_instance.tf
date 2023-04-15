
resource "google_sql_database_instance" "invy" {
  name             = "invy-${local.env}"
  project          = local.project
  database_version = "POSTGRES_13"
  region           = local.default_region
  settings {
    tier              = "db-f1-micro"
    availability_type = "REGIONAL"

    ip_configuration {
      ipv4_enabled = true
    }

    database_flags {
      name  = "max_connections"
      value = "1000"
    }

    backup_configuration {
      enabled                        = true
      location                       = "asia"
      start_time                     = "21:00" # 日本時間6時〜
      point_in_time_recovery_enabled = true
    }
    user_labels = {
      "environment" = local.env
    }

    maintenance_window {
      # 日本時間で月曜日の朝4時
      day          = 7  # Sunday
      hour         = 19 # UTC hour
      update_track = "stable"
    }

    insights_config {
      query_insights_enabled = true
    }
  }

  deletion_protection = true
}

resource "google_sql_database" "invy" {
  name     = "invy"
  instance = google_sql_database_instance.invy.name
}

resource "google_sql_user" "postgres" {
  name     = "postgres"
  instance = google_sql_database_instance.invy.name
  password = data.google_secret_manager_secret_version.invy_db_password.secret_data
}
