resource "helm_release" "traefik" {
  name                  = "traefik"
  chart                 = "traefik"
  repository            = "https://charts.iits.tech"
  version               = local.chart_versions.traefik
  namespace             = "routing"
  create_namespace      = true
  wait                  = true
  atomic                = true
  timeout               = 300
  render_subchart_notes = true
  dependency_update     = true
  wait_for_jobs         = true
  values = [
    yamlencode({
      defaultCert = {
        dnsNames = [
          var.domain_name,
          "*.${var.domain_name}",
        ]
      }
      ingressRoute = {
        healthcheck = {
          enabled = true
        }
      }
      traefik = {
        additionalArguments = [
          "--ping",
          "--entryPoints.web.forwardedHeaders.trustedIPs=100.125.0.0/16",
          "--entryPoints.websecure.forwardedHeaders.trustedIPs=100.125.0.0/16",
        ]
        service = {
          annotations = {
            "yawol.stackit.cloud/existingFloatingIP" = data.terraform_remote_state.infrastructure.outputs.elb["public_ip"]
          }
        }
      }
    })
  ]
}


resource "helm_release" "cert-manager" {
  name                  = "cert-manager"
  chart                 = "cert-manager"
  repository            = "https://charts.jetstack.io"
  version               = local.chart_versions.cert-manager
  namespace             = "cert-manager"
  create_namespace      = true
  wait                  = true
  atomic                = true
  timeout               = 900 // 15 Minutes
  render_subchart_notes = true
  dependency_update     = true
  wait_for_jobs         = true
  depends_on = [helm_release.traefik]
}


resource "helm_release" "stackit_cert_manager_webhook" {
  name                  = "stackit-cert-manager-webhook"
  chart                 = "../../../charts/stackit-cert-manager-webhook"
  namespace             = "stackit-cert-manager-webhook"
  create_namespace      = true
  wait                  = true
  atomic                = true
  timeout               = 900 // 15 Minutes
  render_subchart_notes = true
  dependency_update     = true
  wait_for_jobs         = true
  depends_on = [helm_release.cert-manager]
  set_sensitive {
    name  = "clusterIssuer.authToken"
    value = base64encode(var.cert_manager_auth_token)
  }
  values = [
    yamlencode({
      clusterIssuer = {
        projectID= var.project_id
        email= var.email
      }
    })
  ]
}
