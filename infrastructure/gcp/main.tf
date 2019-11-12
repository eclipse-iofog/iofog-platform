variable "google_application_credentials"           {}
variable "project_id"           {}
variable "environment"          {}
variable "gcp_region"           {}
variable "gcp_service_account"  {}
variable "packet_auth_token" {
  type = string
  default = ""
}
variable "packet_project_id" {
  type = string
  default = ""
}
variable "packet_operating_system" {
  default =  "ubuntu_16_04"
}
variable "packet_count_x86" {
  default = "0"
}
variable "packet_plan_x86" {
  default = "c1.small.x86"
}
variable "packet_count_arm" {
  default = "0"
}
variable "packet_plan_arm" {
  default = "c2.large.arm"
}
variable "packet_facility" {
  type = list(string)
  default = ["sjc1", "ewr1"]
}

provider "google" {
    version                     = "~> 2.19.0"
    credentials                 = file(var.google_application_credentials)
    project                     = var.project_id
    region                      = var.gcp_region
}

provider "google-beta" {
    version                     = "~> 2.19.0"
    region                      = var.gcp_region
    credentials                 = file(var.google_application_credentials)
}


#############################################################
# Setup network vpc and subnets on GCP
#############################################################
module "gcp_network" {
  source = "../modules/vpc"

  project_id   = var.project_id
  network_name = var.environment
  region       = var.gcp_region
}

#############################################################
# Spin up GKE cluster on GCP after setting up the network 
#############################################################
module "kubernetes" {
  source = "../modules/gke"

  project_id       = var.project_id
  gke_name         = var.environment
  gke_region       = var.gcp_region
  gke_network_name = module.gcp_network.network_name
  gke_subnetwork   = module.gcp_network.subnets_names[0]
  service_account  = var.gcp_service_account
}

# ##########################################################################
# # Spin up edge nodes on Packet
# ##########################################################################
module "packet_edge_nodes" {
  source  = "../modules/packet_edge_nodes"

  packet_auth_token           = var.packet_auth_token
  project_id                  = var.packet_project_id
  operating_system            = var.packet_operating_system
  facility                    = var.packet_facility
  count_x86                   = var.packet_count_x86
  plan_x86                    = var.packet_plan_x86
  count_arm                   = var.packet_count_arm
  plan_arm                    = var.packet_plan_arm
  environment                 = var.environment
}

output "kubeconfig" {
  value = module.kubernetes.kubeconfig
}

output "packet_instance_ip_addrs" {
  value = module.packet_edge_nodes.edge_nodes
}

output "ecn_yaml" {
  value = templatefile("${path.module}/../../ecn/template.yaml", {
    kubeconfig = module.kubernetes.kubeconfig
    agent_ips = module.packet_edge_nodes.edge_nodes
  })
}
