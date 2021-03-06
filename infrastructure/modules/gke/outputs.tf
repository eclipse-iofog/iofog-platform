# GKE outputs
output "endpoint" {
    description = "Cluster endpoint"
    value       = "${module.gke.endpoint}"
}

output "ca_certificate" {
    description = "Cluster ca_certificate"
    value       = "${module.gke.ca_certificate}"
}

output "logging_service" {
    description = "Logging service used"
    value       = "${module.gke.logging_service}"
}

output "name" {
    description = "Cluster name"
    value       = "${module.gke.name}"
}

output "region" {
    description = "Cluster region"
    value       = "${module.gke.region}"
}

output "kubeconfig" {
    value = "${var.gke_name}.kubeconfig"
}
