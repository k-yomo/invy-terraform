
resource "google_service_account" "invy_api" {
  account_id   = "invy-api-${local.env}"
  display_name = "'invy-api-${local.env}' Service Account"
}

resource "google_project_iam_member" "invy_api_is_cloudtrace_agent" {
  project = local.project
  member  = "serviceAccount:${google_service_account.invy_api.email}"
  role    = "roles/cloudtrace.agent"
}

resource "google_service_account" "terraform_ci" {
  account_id   = "terraform-ci-${local.env}"
  display_name = "'terraform-ci-${local.env}' Service Account"
}

resource "google_project_iam_member" "terraform_ci_is_owner" {
  project = local.project
  member  = "serviceAccount:${google_service_account.terraform_ci.email}"
  role    = "roles/owner"
}

resource "google_service_account" "api_ci" {
  account_id   = "api-ci-${local.env}"
  display_name = "'api-ci-${local.env}' Service Account"
}

resource "google_project_iam_member" "api_ci_is_iam_service_account_user" {
  project = local.project
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.api_ci.email}"
}

resource "google_service_account" "codemagic" {
  account_id   = "codemagic-${local.env}"
  display_name = "'codemagic-${local.env}' Service Account"
}

resource "google_service_account_key" "codemagic" {
  service_account_id = google_service_account.codemagic.id
}

resource "google_project_iam_member" "codemagic_is_firebaseappdistro_admin" {
  project = local.project
  role    = "roles/firebaseappdistro.admin"
  member  = "serviceAccount:${google_service_account.codemagic.email}"
}
