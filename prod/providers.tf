provider "google" {
  project = local.project
  region  = local.default_region
}

provider "google-beta" {
  project = local.project
  region  = local.default_region
}
