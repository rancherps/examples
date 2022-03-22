resource "rancher2_cluster" "calico" {
  name        = "calico"
  description = "Calico test cluster"
  rke_config {
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
  }
}

resource "rancher2_node_pool" "calico-control" {
  cluster_id       = rancher2_cluster.calico.id
  name             = "calico-control"
  hostname_prefix  = "calico-control"
  node_template_id = data.rancher2_node_template.g1-2x8x40-ubuntu.id
  quantity         = 1
  control_plane    = true
  etcd             = true
  worker           = false
}

resource "rancher2_node_pool" "calico-worker" {
  cluster_id       = rancher2_cluster.calico.id
  name             = "calico-worker"
  hostname_prefix  = "calico-worker"
  node_template_id = data.rancher2_node_template.g1-2x8x40-ubuntu.id
  quantity         = 1
  control_plane    = false
  etcd             = false
  worker           = true
}

resource "local_file" "calico_kubeconfig" {
  filename = "${path.root}/calico_cluster_kubeconfig.yaml"
  content  = rancher2_cluster.calico.kube_config
}

resource "rancher2_cluster_sync" "calico" {
  cluster_id    = rancher2_cluster.calico.id
  node_pool_ids = [rancher2_node_pool.calico-control.id, rancher2_node_pool.calico-worker.id]
}

