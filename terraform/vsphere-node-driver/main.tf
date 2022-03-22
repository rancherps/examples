module "rke-rancher" {
  source    = "./modules/nodes"
  num       = 3
  cpus      = 2
  memory    = var.rancher_memory
  name      = "rancher"
  disk_size = 40

  template_uuid    = data.vsphere_virtual_machine.template.id
  guest_id         = data.vsphere_virtual_machine.template.guest_id
  resource_pool_id = data.vsphere_resource_pool.pool.id

  datastore_id = data.vsphere_datastore.datastore.id
  network_id   = data.vsphere_network.network.id
  adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]

  domain_name = var.domain
  ssh_user    = var.ssh_user
}

resource "rke_cluster" "rancher" {
  ssh_agent_auth     = true
  kubernetes_version = var.kubernetes_version
  network {
    plugin = "calico"
  }

  addons = <<EOL
---
apiVersion: crd.projectcalico.org/v1
kind: FelixConfiguration
metadata:
  name: default
spec:
  wireguardEnabled: true
EOL

  dynamic "nodes" {
    for_each = module.rke-rancher.nodes
    content {
      hostname_override = module.rke-rancher.nodes[nodes.key]
      address           = module.rke-rancher.ip_addresses[nodes.key]
      user              = var.ssh_user
      role              = ["controlplane", "etcd", "worker"]
    }
  }
}

resource "local_file" "kube_cluster_yaml" {
  filename = "${path.root}/kube_config_cluster.yml"
  content  = rke_cluster.rancher.kube_config_yaml
}

resource "helm_release" "keepalived" {
  name             = "keepalived-ingress-vip"
  chart            = "keepalived-ingress-vip"
  repository       = "https://janeczku.github.io/helm-charts/"
  namespace        = "kube-system"
  create_namespace = true

  set {
    name  = "keepalived.vipInterfaceName"
    value = var.keepalived_vip_interface
  }
  set {
    name  = "keepalived.vrrpInterfaceName"
    value = var.keepalived_vrrp_interface
  }
  set {
    name  = "keepalived.vipAddressCidr"
    value = "${var.rancher_vip}/24"
  }
  set {
    name  = "keepalived.checkServiceUrl"
    value = "http://127.0.0.1:80/healthz"
  }
  set {
    name  = "pod.replicas"
    value = length(module.rke-rancher.nodes)
  }
  set {
    name  = "pod.resources.limits.memory"
    value = "48Mi"
  }
  set {
    name  = "keepalived.checkServiceUrl"
    value = "http://127.0.0.1:80/healthz"
  }
}

resource "helm_release" "cert-manager" {
  name             = "cert-manager"
  chart            = "cert-manager"
  namespace        = "cert-manager"
  repository       = "https://charts.jetstack.io"
  create_namespace = true

  set {
    name  = "installCRDs"
    value = "true"
  }
  depends_on = [
    helm_release.keepalived
  ]
}

# Workaround https://github.com/rancher/rancher/issues/36108 which appears
# intermittently during provisioning
#
resource "null_resource" "delete_nginx_vwc" {
  provisioner "local-exec" {
    command = "kubectl --kubeconfig ${local_file.kube_cluster_yaml.filename} delete -A ValidatingWebhookConfiguration ingress-nginx-admission"
  }
}

resource "helm_release" "rancher" {
  name             = "rancher"
  chart            = "rancher"
  version          = var.rancher_version
  namespace        = "cattle-system"
  create_namespace = true
  repository       = "https://releases.rancher.com/server-charts/latest"

  set {
    name  = "hostname"
    value = var.rancher_fqdn
  }

  set {
    name  = "antiAffinity"
    value = "required"
  }

  set {
    name  = "bootstrapPassword"
    value = var.initial_password
  }

  depends_on = [
    helm_release.keepalived,
    helm_release.cert-manager,
    null_resource.delete_nginx_vwc
  ]
}

resource "rancher2_bootstrap" "admin" {
  provider         = rancher2.bootstrap
  initial_password = var.initial_password
  password         = var.admin_password
  telemetry        = true
  depends_on = [
    helm_release.rancher
  ]
}

resource "rancher2_auth_config_activedirectory" "activedirectory" {
  servers                         = var.ad_server
  tls                             = false
  port                            = 389
  service_account_username        = var.ad_username
  service_account_password        = var.ad_password
  test_username                   = var.ad_username
  test_password                   = var.ad_password
  default_login_domain            = var.ad_default_login_domain
  user_search_base                = var.ad_user_search_base
  group_search_base               = var.ad_group_search_base
  nested_group_membership_enabled = true

  count = var.enable_active_directory ? 1 : 0
}

resource "rancher2_cloud_credential" "vsphere" {
  name        = "vSphere"
  description = "vSphere Cloud Credentials"
  vsphere_credential_config {
    vcenter  = var.vsphere_server
    username = var.vsphere_user
    password = var.vsphere_password
  }
}

resource "rancher2_node_template" "g1-2x8x40-ubuntu" {
  name                = "g1-2x8x40-ubuntu"
  description         = "2 vCPU, 8GB RAM, 40GB Disk, Ubuntu 20.04"
  cloud_credential_id = rancher2_cloud_credential.vsphere.id
  vsphere_config {
    cpu_count     = "2"
    memory_size   = "8192"
    disk_size     = "400000"
    network       = ["/${var.vsphere_datacenter}/network/pgK8s"]
    creation_type = "template"
    datacenter    = "/${var.vsphere_datacenter}"
    datastore     = "/${var.vsphere_datacenter}/datastore/ds01"
    pool          = "/${var.vsphere_datacenter}/host/esxi01.42can.org/Resources"
    clone_from    = "/${var.vsphere_datacenter}/vm/templates/template_ubuntu_2004"
    cfgparam      = ["disk.enableUUID=TRUE"]
    folder        = "/${var.vsphere_datacenter}/vm/Rancher"
  }
}
