provider "google" {
  project = local.project
  region  = local.default_region
}

provider "google-beta" {
  project = local.project
  region  = local.default_region
}

provider "upstash" {
  email   = "kanji.yy@gmail.com"
  api_key = var.upstash_api_key
}