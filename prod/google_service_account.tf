
resource "google_service_account" "invy_api" {
  account_id   = "invy-api-${local.env}"
  display_name = "'invy-api-${local.env}' Service Account"
}

resource "google_service_account" "terraform_ci" {
  account_id   = "terraform-ci-${local.env}"
  display_name = "'terraform-ci-${local.env}' Service Account"
}

resource "google_service_account" "api_ci" {
  account_id   = "api-ci-${local.env}"
  display_name = "'api-ci-${local.env}' Service Account"
}

resource "google_service_account" "codemagic" {
  account_id   = "codemagic-${local.env}"
  display_name = "'codemagic-${local.env}' Service Account"
}

resource "google_service_account_key" "codemagic" {
  service_account_id = google_service_account.codemagic.id
}
