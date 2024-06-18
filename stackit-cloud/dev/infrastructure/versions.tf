terraform {
  required_version = "v1.5.7"
  backend "s3" {
    bucket                      = "summit-dev-tfstate"
    key                         = "tfstate-infrastructure"
    region                      = "eu01"
    skip_region_validation      = true
    skip_credentials_validation = true
    endpoint = "https://object.storage.eu01.onstackit.cloud"
  }
  required_providers {
    stackit = {
      source = "stackitcloud/stackit"
      version = "0.19.0"
    }
  }
}