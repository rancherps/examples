variable "vsphere_user" {
  description = "Username to connect to vSphere with"
  default     = "administrator@vsphere.local"
}

variable "vsphere_password" {
  default = ""
}

variable "vsphere_server" {
  description = "FQDN to vSphere"
  default     = ""
}

variable "vsphere_datacenter" {
  description = "Datacenter in which to deploy resources"
  default     = ""
}

variable "vsphere_datastore" {
  description = "Datastore in which to create resources"
  default     = ""
}

variable "vsphere_resource_pool" {
  description = "vSphere resource pool to be used"
  default     = ""
}

variable "vsphere_network" {
  description = "Network to connect nodes to"
  default     = ""
}

variable "vsphere_template" {
  default = "templates/template_ubuntu2004_esxi_docker"
}

variable "num_control" {
  description = "Number of nodes to be created with the controlplane role"
  default     = "1"
}

variable "num_etcd" {
  description = "Number of nodes to be created with the etcd role"
  default     = "1"
}

variable "num_worker" {
  description = "Number of nodes to be created with the worker role"
  default     = "1"
}

variable "rancher_hostname" {
  default = ""
}

variable "rancher_access_key" {
  default = ""
}

variable "rancher_secret_key" {
  default = ""
}

variable "control_cpus" {
  default = "2"
}

variable "etcd_cpus" {
  default = "2"
}

variable "worker_cpus" {
  default = "2"
}

variable "control_memory" {
  default = "2048"
}

variable "etcd_memory" {
  default = "4096"
}

variable "worker_memory" {
  default = "4096"
}

variable "kubernetes_version" {
  description = "Version of Kubernetes to deploy"
  default     = "v1.19.3-rancher1-2"
}

variable "ssh_user" {
  description = "Username for SSH access to VMs"
  default     = "packerbuilt"
}

variable "ssh_password" {
  description = "Password for the ssh_user"
  default     = "PackerBuilt!"
}

variable "cluster_name" {
  default     = "demo"
  description = "Name of cluster"
}

variable "cluster_description" {
  default     = "Demo cluster"
  description = "Description of purpose of cluster"
}
