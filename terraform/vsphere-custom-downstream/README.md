# Downstream cluster deployment on vSphere with the custom node driver

This is some proof-of-concept code to:

* Create a set of instances on vSphere
* Create a cluster definition in Rancher
* Bootstrap Kubernetes on these instances using the custom node driver

## Pre-requisites
This Terraform code assumes a couple of things about the virtual machines themselves as they've been provisioned:

* Nodes receive an IP via DHCP
* SSH into nodes is via a username and password specificed in the image
* Operating system image has Docker pre-installed

There is a Packer build script included which creates a working template with those pre-requisites in place.

You will also need a Rancher API key generated so that Terraform can create the cluster definition and retrieve the bootstrap command and token.

## Running
Copy this code into a folder, and then create a `terraform.tfvars` file with at least the following options set:

* `vsphere_server`
* `vsphere_password`
* `vsphere_resource_pool`
* `vsphere_datacenter`
* `vsphere_datastore`
* `vsphere_network`
* `rancher_hostname`
* `rancher_access_key`
* `rancher_secret_key`

