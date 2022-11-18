
resource "google_dns_managed_zone" "invy_app_dev" {
  name     = "invy-app-dev"
  dns_name = "invy-app.dev."

  lifecycle {
    prevent_destroy = true
  }
}
