output "rancher_hosts" {
  value = module.rke-rancher.nodes
}

output "rancher_url" {
  value = "https://${var.rancher_fqdn}"
}

#output downstream_cluster_hosts {
#  value = local.downstream_cluster_nodes
#}

