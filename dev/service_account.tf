
resource "google_service_account" "invy_api" {
  account_id   = "invy-api-${local.env}"
  display_name = "'invy-api-${local.env}' Service Account"
}
