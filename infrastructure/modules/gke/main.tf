#############################################################
# Spin GKE cluster on GCP
# Store encrypted kubeconfig in storage bucket
#############################################################
variable "project_id"           {}
variable "gke_name"             {}
variable "gke_region"           {}
variable "gke_network_name"     {}
variable "gke_subnetwork"       {}
variable "service_account"      {}

# Use GKE module to setup a k8s cluster with specified node pool
module "gke" {
    source                      = "terraform-google-modules/kubernetes-engine/google"
    version                     = "4.1.0"
    project_id                  = "${var.project_id}"
    name                        = "${var.gke_name}"
    regional                    = true
    region                      = "${var.gke_region}"
    network                     = "${var.gke_network_name}"
    network_project_id          = "${var.project_id}"
    subnetwork                  = "${var.gke_subnetwork}"
    service_account             = "${var.service_account}"
    ip_range_pods               = "${var.gke_network_name}-pods"
    ip_range_services           = "${var.gke_network_name}-services"
    http_load_balancing         = false
    horizontal_pod_autoscaling  = true
    kubernetes_dashboard        = true
    network_policy              = true

    node_pools = [
    {
        name                    = "${var.gke_name}-node-pool"
        machine_type            = "n1-standard-1"
        min_count               = 1
        max_count               = 20
        disk_size_gb            = 20
        disk_type               = "pd-standard"
        image_type              = "COS"
        auto_repair             = true
        auto_upgrade            = true
        service_account         = "${var.service_account}"
        preemptible             = false
        initial_node_count      = 1
    }]

    node_pools_oauth_scopes = {
        all = []
        "${var.gke_name}-node-pool" = [
            "https://www.googleapis.com/auth/cloud-platform",
        ]
    }
    node_pools_tags = {
        all = ["${var.gke_name}-node-tags",]
        "${var.gke_name}-node-pool" = []
    }
    node_pools_taints = {
        all = []
        "${var.gke_name}-node-pool" = []
    }
    node_pools_labels = {
        all = {
            cluster = "${var.gke_name}"
        }
        "${var.gke_name}-node-pool" = {}
    }
    node_pools_metadata = {
        all = {}

        "${var.gke_name}-node-pool" = {}
    }
}

resource "null_resource" "fetch_kubeconfig" {
    triggers = {
        exists = tostring(fileexists("${var.gke_name}.kubeconfig"))
    }
    provisioner "local-exec" {
        environment = {
            KUBECONFIG = "${var.gke_name}.kubeconfig"
        }
        command = "gcloud container clusters get-credentials ${module.gke.name} --region ${module.gke.region} --project ${var.project_id}"
    }
    provisioner "local-exec" {
        when    = "destroy"
        command = "rm -f ./${var.gke_name}.kubeconfig"
    }
    depends_on = ["module.gke"]
}
