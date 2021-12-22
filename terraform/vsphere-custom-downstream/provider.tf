provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

provider "rancher2" {

  api_url    = "https://${var.rancher_hostname}/v3"
  access_key = var.rancher_access_key
  secret_key = var.rancher_secret_key
}
