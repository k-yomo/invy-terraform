
resource "google_project_iam_member" "invy_api_is_cloudtrace_agent" {
  project = local.project
  member  = "serviceAccount:${google_service_account.invy_api.email}"
  role    = "roles/cloudtrace.agent"
}

# serviceAccountTokenCreator needed to sign gcs image url
resource "google_project_iam_member" "invy_api_is_service_account_token_creator" {
  project = local.project
  member  = "serviceAccount:${google_service_account.invy_api.email}"
  role    = "roles/iam.serviceAccountTokenCreator"
}

resource "google_project_iam_member" "api_ci_is_iam_service_account_user" {
  project = local.project
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.api_ci.email}"
}

resource "google_project_iam_member" "codemagic_is_firebaseappdistro_admin" {
  project = local.project
  role    = "roles/firebaseappdistro.admin"
  member  = "serviceAccount:${google_service_account.codemagic.email}"
}
