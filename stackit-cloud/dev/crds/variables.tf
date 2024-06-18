data "terraform_remote_state" "infrastructure" {
  backend = "s3"
  config = {
    bucket                      = "${var.context}-${var.stage}-tfstate"
    key                         = "tfstate-infrastructure"
    region                      = "eu01"
    skip_region_validation      = true
    skip_credentials_validation = true
    endpoint = "https://object.storage.eu01.onstackit.cloud"
  }
}

variable "context" {
  type        = string
  description = "Project context for resource naming and tagging."
}

variable "stage" {
  type        = string
  description = "Project stage for resource naming and tagging."
}