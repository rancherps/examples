variable "vsphere_user" {
  description = "vSphere username"
  default     = "Administrator@vsphere.local"
}

variable "vsphere_password" {
  description = "vSphere password"
  default     = ""
}

variable "vsphere_server" {
  description = "vSphere vCenter URL"
  default     = "vsphere.int.dischord.org"
}

variable "vsphere_datacenter" {
  description = "Target vSphere datacenter"
  default     = ""
}

variable "vsphere_network" {
  description = "vSphere network"
  default     = "vmGuests"
}

variable "vsphere_resource_pool" {
  description = "vSphere Resource Pool"
  default     = ""
}

variable "vsphere_datastore" {
  description = "vSphere Datastore"
  default     = "ds01"
}

variable "admin_password" {
  description = "Rancher admin password"
  default     = "658e9beb-5ca4-40a0-87ae-90fef733758a"
}

variable "initial_password" {
  description = "Initial Rancher password"
  default     = "a2f9fdc8-fede-411f-bfee-4569f1f0ab41"
}

variable "vsphere_vm_template" {
  description = "Template to use for all VMs"
  default     = "template_opensuse"
}

variable "ad_server" {
  description = "Active Directory server(s) IP or hostname"
  default     = [""]
}

variable "ad_username" {
  description = "Active Directory service account used for lookups"
  default     = ""
}

variable "ad_password" {
  description = "Active Directory password"
  default     = ""
}

variable "ad_user_search_base" {
  description = "AD user search base"
  default     = ""
}

variable "ad_group_search_base" {
  description = "AD group search base"
  default     = ""
}

variable "ad_default_login_domain" {
  description = "Default AD login domain"
  default     = ""
}

variable "domain" {
  description = "Domain suffix"
  default     = "42can.org"
}

variable "rancher_vip" {
  description = "IP address of VIP for Rancher"
  default     = "192.168.20.215"
}

variable "rancher_fqdn" {
  description = "FQDN for Rancher Server.  Should resolve to the value of rancher_vip"
  default = "rancher.192.168.20.215.dnsify.me"
}

variable "rancher_memory" {
  description = "How much memory to allocate to Rancher Server instances"
  default     = 8192
}

variable "rancher_disk" {
  description = "How much disk to allocate to Rancher Server instances"
  default     = 20
}

variable "rancher_version" {
  description = "Version of Rancher Server to deploy"
  default     = "2.6.3"
}

variable "kubernetes_version" {
  description = "Version of Kubernetes to deploy"
  default     = "v1.21.7-rancher1-1"
}

variable "downstream_kubernetes_version" {
  description = "Version of Kubernetes to deploy on downstream cluster"
  default     = "v1.21.7-rancher1-1"
}

variable "control_memory" {
  description = "How much memory to allocate to downstream cluster nodes"
  default     = 2048
}

variable "control_cpus" {
  default = "2"
}

variable "worker_memory" {
  default = "4096"
}

variable "worker_cpus" {
  default = "4"
}

variable "downstream_cluster_disk" {
  description = "How much disk to allocate to downstream cluster nodes"
  default     = 20
}

variable "downstream_cluster_name" {
  default = "demo"
}

variable "downstream_cluster_description" {
  default = "Demo cluster"
}

variable "num_control" {
  description = "Number of downstream nodes to deploy with controlplane and etcd roles"
  default     = "1"
}

variable "num_worker" {
  default     = "1"
  description = "Number of downstream worker nodes to deploy"
}

variable "ssh_user" {
  description = "Username for SSH access to VMs"
  default     = "packerbuilt"
}

variable "ssh_password" {
  description = "Password for SSH access to VMs"
  default     = "PackerBuilt!"
}

variable "keepalived_vip_interface" {
  description = "Interface to which the VIP should be assigned"
  default     = "eth0"
}

variable "keepalived_vrrp_interface" {
  description = "Interface used for VRRP traffic"
  default     = "eth0"
}

variable "enable_monitoring" {
  description = "Whether or not to enable monitoring"
  default     = false
}

variable "enable_active_directory" {
  description = "Whether or not to enable Rancher AD integration"
  default     = false
}
