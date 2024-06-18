locals {
  public_ip = "193.148.169.144"
}

resource "stackit_ske_cluster" "private_llm" {
  project_id = var.project_id
  name       = "${var.context}-${var.stage}"

  node_pools = [
    {
      name               = "standard"
      machine_type       = "g1.3"
      minimum            = "2"
      maximum            = "3"
      availability_zones = ["eu01-3"]
      os_version         = "3815.2.1"
      volume_size = 20
      volume_type = "storage_premium_perf1"
    },
    {
      name            = "gpu-nodes"
      availability_zones = ["eu01-3"]
      cri             = "containerd"
      machine_type    = "n1.14d.g1"
      minimum         = "1"
      maximum         = "1"
      os_name         = "ubuntu"
      os_version = "2204.20240514.0"
      taints          = [
        {
          effect = "PreferNoSchedule"
          key    = "gpu-node"
          value  = "true"
        }
      ]
      volume_size = 20
      volume_type = "storage_premium_perf2"
    },

  ]
}

resource "stackit_dns_zone" "private_llm" {
  project_id    = var.project_id
  name          = "Private LLM Zone"
  dns_name      = var.domain_name
  contact_email = var.email
}

resource "stackit_dns_record_set" "ollama" {
  project_id = var.project_id
  zone_id    = stackit_dns_zone.private_llm.zone_id
  name       = "ollama.${var.domain_name}"
  type       = "A"
  records    = [local.public_ip]
}

resource "stackit_dns_record_set" "llm" {
  project_id = var.project_id
  zone_id    = stackit_dns_zone.private_llm.zone_id
  name       = "llm.${var.domain_name}"
  type       = "A"
  records    = [local.public_ip]
}

resource "stackit_ske_kubeconfig" "private_llm" {
  project_id   = var.project_id
  cluster_name = stackit_ske_cluster.private_llm.name
  refresh      = true
}

resource "null_resource" "get_kube_config" {
  depends_on = [stackit_ske_cluster.private_llm]
  provisioner "local-exec" {
    command = "../stage-dependent-env.sh"
  }
}