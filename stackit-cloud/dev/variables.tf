variable "region" {
  type        = string
  description = "STACKIT region for the project: eu01(default)"
  default     = "eu01"
  validation {
    condition     = contains(["eu01"], var.region)
    error_message = "Currently only this regions are supported: \"eu01\""
  }
}

variable "project_id" {
  description = "STACKIT project id"
}

variable "context" {
  type        = string
  description = "Project context for resource naming and tagging."
}

variable "stage" {
  type        = string
  description = "Project stage for resource naming and tagging."
}

locals {
  tf_state_bucket_name = "${var.context}-${var.stage}-tfstate"
  terraform_paths = [
    "infrastructure",
    "crds",
    "kubernetes"
  ]
}