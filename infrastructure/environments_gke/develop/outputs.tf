# VPC Outputs
output "network_name" {
  description = "The name of the VPC being created"
  value       = module.gcp_network.network_name
}

output "routes" {
  description = "The routes associated with this VPC"
  value       = module.gcp_network.routes
}

output "subnets_ips" {
  description = "The IPs and CIDRs of the subnets being created"
  value       = module.gcp_network.subnets_ips
}

output "subnets_names" {
  description = "The names of the subnets being created"
  value       = module.gcp_network.subnets_names
}

output "subnets_secondary_ranges" {
  description = "The secondary ranges associated with these subnets"
  value       = module.gcp_network.subnets_secondary_ranges
}

# GKE
output "name" {
    description = "Cluster name"
    value       = "${module.kubernetes.name}"
}

output "region" {
    description = "Cluster region"
    value       = "${module.kubernetes.region}"
}

# Packet ips
output "packet_instance_ip_addrs" {
  value = module.packet_edge_nodes.edge_nodes
}
