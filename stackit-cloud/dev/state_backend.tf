resource "random_id" "kms_key_unique_suffix" {
  byte_length = 4
}

resource "stackit_objectstorage_bucket" "remote_state_bucket" {
  project_id = var.project_id
  name     = local.tf_state_bucket_name
}

output "terraform_state_backend_config" {
  value = [for path in local.terraform_paths : <<EOT

Place this this under STACKIT-cloud/${var.stage}/${path}/settings.tf under TODO !

    backend "s3" {
      bucket                      = "${stackit_objectstorage_bucket.remote_state_bucket.name}"
      key                         = "tfstate-${path}"
      region                      = "${var.region}"
      skip_region_validation      = true
      skip_credentials_validation = true
      endpoint = "https://object.storage.${var.region}.onstackit.cloud"
    }
  EOT
  ]
}
