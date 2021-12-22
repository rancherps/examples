output "control" {
  value = zipmap(module.rke-control.nodes, module.rke-control.ip_addresses)
}

output "etcd" {
  value = zipmap(module.rke-etcd.nodes, module.rke-etcd.ip_addresses)
}

output "worker" {
  value = zipmap(module.rke-worker.nodes, module.rke-worker.ip_addresses)
}


