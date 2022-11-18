data "google_secret_manager_secret_version" "invy_db_password" {
  provider = google-beta
  secret   = "INVY_DB_PASSWORD"
}

data "google_secret_manager_secret" "invy_db_password" {
  provider  = google-beta
  secret_id = "INVY_DB_PASSWORD"
}
resource "google_secret_manager_secret_iam_binding" "invy_db_password_secret_accessor" {
  secret_id = data.google_secret_manager_secret_version.invy_db_password.secret
  role      = "roles/secretmanager.secretAccessor"
  members    = ["serviceAccount:${google_service_account.invy_api.email}"]
}
