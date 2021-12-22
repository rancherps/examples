module "rke-control" {
  source = "./modules/nodes"
  num    = var.num_control
  name   = "control"
  cpus   = var.control_cpus
  memory = var.control_memory

  template_uuid    = data.vsphere_virtual_machine.template.id
  guest_id         = data.vsphere_virtual_machine.template.guest_id
  resource_pool_id = data.vsphere_resource_pool.pool.id

  datastore_id = data.vsphere_datastore.datastore.id
  network_id   = data.vsphere_network.network.id
  adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]

  domain_name = "int.dischord.org"

  tags = [vsphere_tag.controlplane.id]
}

module "rke-etcd" {
  source = "./modules/nodes"
  num    = var.num_etcd
  name   = "etcd"
  cpus   = var.etcd_cpus
  memory = var.etcd_memory

  template_uuid    = data.vsphere_virtual_machine.template.id
  guest_id         = data.vsphere_virtual_machine.template.guest_id
  resource_pool_id = data.vsphere_resource_pool.pool.id

  datastore_id = data.vsphere_datastore.datastore.id
  network_id   = data.vsphere_network.network.id
  adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]

  domain_name = "int.dischord.org"

  tags = [vsphere_tag.etcd.id]
}

module "rke-worker" {
  source = "./modules/nodes"
  num    = var.num_worker
  name   = "worker"
  cpus   = var.worker_cpus
  memory = var.worker_memory

  template_uuid    = data.vsphere_virtual_machine.template.id
  guest_id         = data.vsphere_virtual_machine.template.guest_id
  resource_pool_id = data.vsphere_resource_pool.pool.id

  datastore_id = data.vsphere_datastore.datastore.id
  network_id   = data.vsphere_network.network.id
  adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]

  domain_name = "int.dischord.org"

  tags = [vsphere_tag.worker.id]
}

resource "rancher2_cluster" "downstream_cluster" {
  name        = var.cluster_name
  description = var.cluster_description

  rke_config {
    kubernetes_version = var.kubernetes_version
    services {
      kube_api {
        secrets_encryption_config {
          enabled = true
        }
      }
    }
  }
}

resource "null_resource" "downstream_cluster_etcd_deploy" {
  for_each = zipmap(module.rke-etcd.nodes, module.rke-etcd.ip_addresses)

  provisioner "remote-exec" {
    inline = ["${rancher2_cluster.downstream_cluster.cluster_registration_token.0["node_command"]} --etcd"]
    connection {
      host        = each.value
      user        = var.ssh_user
      password    = var.ssh_password
      type        = "ssh"
      script_path = "~${var.ssh_user}/rke.sh"
    }
  }
  depends_on = [rancher2_cluster.downstream_cluster]
}

resource "null_resource" "downstream_cluster_controlplane_deploy" {
  for_each = zipmap(module.rke-control.nodes, module.rke-control.ip_addresses)

  provisioner "remote-exec" {
    inline = ["${rancher2_cluster.downstream_cluster.cluster_registration_token.0["node_command"]} --controlplane"]
    connection {
      host        = each.value
      user        = var.ssh_user
      password    = var.ssh_password
      type        = "ssh"
      script_path = "~${var.ssh_user}/rke.sh"
    }
  }
  depends_on = [rancher2_cluster.downstream_cluster]
}

resource "null_resource" "downstream_cluster_worker_deploy" {
  for_each = zipmap(module.rke-worker.nodes, module.rke-worker.ip_addresses)

  provisioner "remote-exec" {
    inline = ["${rancher2_cluster.downstream_cluster.cluster_registration_token.0["node_command"]} --worker"]
    connection {
      host        = each.value
      user        = var.ssh_user
      password    = var.ssh_password
      type        = "ssh"
      script_path = "~${var.ssh_user}/rke.sh"
    }
  }
  depends_on = [rancher2_cluster.downstream_cluster]
}
