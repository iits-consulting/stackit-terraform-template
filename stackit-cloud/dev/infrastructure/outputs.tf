locals {
  kubeconfig = yamldecode(stackit_ske_kubeconfig.private_llm.kube_config)
}

output "kubernetes" {
  sensitive = true
  value = {
    api_endpoint = local.kubeconfig.clusters[0].cluster.server
    client_certificate = local.kubeconfig.users[0].user.client-certificate-data
    client_key = local.kubeconfig.users[0].user.client-key-data
    certificate_authority = local.kubeconfig.clusters[0].cluster.certificate-authority-data
  }
}

output "elb" {
  value = {
    public_ip = local.public_ip
  }
}