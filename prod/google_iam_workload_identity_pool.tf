resource "google_iam_workload_identity_pool" "github" {
  provider                  = google-beta
  workload_identity_pool_id = "github"
  display_name              = "github"
  description               = "for github actions"
}

resource "google_iam_workload_identity_pool_provider" "github" {
  provider                           = google-beta
  workload_identity_pool_id          = google_iam_workload_identity_pool.github.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-provider"
  display_name                       = "github actions provider"
  description                        = "OIDC identity pool provider for execute github actions"
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
  attribute_mapping = {
    "google.subject"        = "assertion.sub"
    "attribute.repository"  = "assertion.repository"
    "attribute.environment" = "assertion.actor"
    "attribute.aud"         = "assertion.aud"
  }
}

resource "google_service_account_iam_binding" "invy_workload_identity_user" {
  service_account_id = google_service_account.api_ci.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.repository/k-yomo/invy"
  ]
}

resource "google_service_account_iam_binding" "invy_terraform_workload_identity_user" {
  service_account_id = google_service_account.terraform_ci.name
  role               = "roles/iam.workloadIdentityUser"
  members = [
    "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github.name}/attribute.repository/k-yomo/invy-terraform"
  ]
}
