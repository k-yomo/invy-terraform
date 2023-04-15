data "google_secret_manager_secret_version" "invy_db_password" {
  provider = google-beta
  secret   = "INVY_DB_PASSWORD"
}

