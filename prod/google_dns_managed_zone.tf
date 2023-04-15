
resource "google_dns_managed_zone" "invy_app_com" {
  name     = "invy-app-com"
  dns_name = "invy-app.com."

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_dns_record_set" "api_invy_app_com" {
  name = "api.${google_dns_managed_zone.invy_app_com.dns_name}"
  type = "CNAME"
  ttl  = 86400

  managed_zone = google_dns_managed_zone.invy_app_com.name

  rrdatas = ["ghs.googlehosted.com."]

  lifecycle {
    prevent_destroy = false
  }
}

resource "google_dns_record_set" "link_invy_app_com" {
  name = "link.${google_dns_managed_zone.invy_app_com.dns_name}"
  type = "A"
  ttl  = 86400

  managed_zone = google_dns_managed_zone.invy_app_com.name

  rrdatas = ["199.36.158.100"]

  lifecycle {
    prevent_destroy = false
  }
}

resource "google_dns_record_set" "invy_app_com_mx" {
  name         = google_dns_managed_zone.invy_app_com.dns_name
  type         = "MX"
  ttl          = 3600
  managed_zone = google_dns_managed_zone.invy_app_com.name

  rrdatas = [
    "1 aspmx.l.google.com.",
    "5 alt1.aspmx.l.google.com.",
    "5 alt2.aspmx.l.google.com.",
    "10 alt3.aspmx.l.google.com.",
    "10 alt4.aspmx.l.google.com.",
  ]
}
