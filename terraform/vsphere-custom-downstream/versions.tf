terraform {
  required_providers {
    rancher2 = {
      source = "rancher/rancher2"
    }
    vsphere = {
      source = "hashicorp/vsphere"
    }
  }
  required_version = ">= 0.13"
}
