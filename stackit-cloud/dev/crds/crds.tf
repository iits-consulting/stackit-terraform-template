module "crds" {
  source  = "../../../modules/crd_installer"
  default_chart_overrides = {
    traefik = {
      version = "28.1.0"
    }
  }
}
