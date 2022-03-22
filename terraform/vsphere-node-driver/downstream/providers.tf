provider "rancher2" {
  api_url = var.rancher_url
  access_key = var.rancher_access_key
  secret_key = var.rancher_secret_key
  insecure = true
}

provider "helm" {
  kubernetes {
    config_path = local_file.longhorn_kubeconfig.filename
  }
}

