
resource "google_dns_managed_zone" "invy_app_com" {
  name     = "invy-app-com"
  dns_name = "invy-app.com."

  lifecycle {
    prevent_destroy = true
  }
}
