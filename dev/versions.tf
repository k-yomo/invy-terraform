terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.61.0"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = "4.61.0"
    }
    upstash = {
      source  = "upstash/upstash"
      version = "1.3.0"
    }
  }
  required_version = "= 1.4.4"
}
