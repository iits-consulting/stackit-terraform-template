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

variable "dockerhub_username" {
  type        = string
  description = "Username of Docker Registry Credentials for ArgoCD"
  sensitive   = true
}

variable "dockerhub_password" {
  type        = string
  description = "Password of Docker Registry Credentials for ArgoCD"
  sensitive   = true
}

variable "domain_name" {
  type        = string
  description = "The public domain to create public DNS zone for."
}

variable "email" {
  description = "E-mail contact address for DNS zone."
  type        = string
}

variable "project_id" {
  description = "STACKIT project id"
}

variable "cert_manager_auth_token" {
  type = string
  validation {
    condition     = var.cert_manager_auth_token != ""
    error_message = "cert_manager_auth_token is mandatory"
  }
}

locals {
  chart_versions = {
    kyverno               = "2.0.1"
    traefik               = "28.1.0"
    cert-manager          = "1.14.4"
    ollama                = "0.8.2"
  }
}