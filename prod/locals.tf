locals {
  env                = "prod"
  project            = "invy-prod"
  dev_project_number = "434214998297"
  project_number     = "936800855868"
  default_region     = "asia-northeast1"
  root_domain        = "invy-app.com"
  api_domain         = "api.${local.root_domain}"
}
