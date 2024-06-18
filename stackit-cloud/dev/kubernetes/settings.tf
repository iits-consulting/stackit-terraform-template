terraform {
  required_version = "v1.5.7"

  backend "s3" {
    bucket                      = "summit-dev-tfstate"
    key                         = "tfstate-kubernetes"
    region                      = "eu01"
    skip_region_validation      = true
    skip_credentials_validation = true
    endpoint = "https://object.storage.eu01.onstackit.cloud"
  }

  required_providers {
    helm = {
      source = "hashicorp/helm"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">=1.14.0"
    }
  }
}