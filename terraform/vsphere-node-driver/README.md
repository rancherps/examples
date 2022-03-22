# Rancher 2.6 and vSphere Node Driver

The Terraform code in this folder should stand up a three-node Kubernetes cluster using RKE and subsequently deploy Rancher 2.6.  An example downstream cluster definition has also been included.

Other things to note:

* It installs keepalived to provide a highly-available IP
* It depends on a functioning OS template that has cloud-init installed.  See [this repo](https://github.com/David-VTUK/Rancher-Packer) for suitable Packer build templates.  The example in this repo has been tested with openSUSE 15.3 and Ubuntu 20.04

