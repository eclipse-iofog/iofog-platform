variable "project_id"           {}
variable "environment"          {}
variable "gcp_region"           {}
variable "gcp_service_account"  {}
variable "controller_ip"        {
    default = ""
}
variable "controller_image"     {
    default = ""
}
variable "connector_image"      {
    default = ""
}
variable "kubelet_image"        {
    default = ""
}
variable "operator_image"       {
    default = ""
}
variable "ssh_key"              {
    default = "/tmp/NotAFile"
}
# Packet Vars
variable "packet_project_id"    {
    default = "invalidProjectId"
}
variable "operating_system"     {
    default =  "ubuntu_16_04"
}
variable "count_x86"            {
    default = "0"
}
variable "plan_x86"             {
    default = "c1.small.x86"
}
variable "count_arm"            {
    default = "0"
}
variable "plan_arm"             {
    default = "c2.large.arm"
}
variable "packet_facility"      {
    type = "list"
    default = ["sjc1", "ewr1"]
}
# iofog user vars
variable "iofogUser_name"       {}
variable "iofogUser_surname"    {}
variable "iofogUser_email"      {}
variable "iofogUser_password"   {}
# iofogctl vars
variable "iofogctl_namespace"   {}
variable "agent_repo"           {
     default = ""
}
variable "agent_version"        {
     default = ""
}
variable "agent_list"      {
    type = "list"
    default = []
}

provider "google" {
    version                     = "~> 2.7.0"
    project                     = "${var.project_id}"
    region                      = "${var.gcp_region}"
}

provider "google-beta" {
    version                     = "~> 2.7.0"
    region                      = "${var.gcp_region}"
}

#############################################################
# Setup network vpc and subnets on GCP
#############################################################
module "gcp_network" {
    source  = "../../modules/gcp_network"

    project_id                  = "${var.project_id}"
    network_name                = "${var.environment}"
    region                      = "${var.gcp_region}"
}

#############################################################
# Spin up GKE cluster on GCP after setting up the network 
#############################################################
module "kubernetes" {
    source  = "../../modules/gke"

    project_id                  = "${var.project_id}"
    gke_name                    = "${var.environment}"
    gke_region                  = "${var.gcp_region}"
    gke_network_name            = "${module.gcp_network.network_name}"
    gke_subnetwork              = "${module.gcp_network.subnets_names[0]}"
    service_account             = "${var.gcp_service_account}"
}

#############################################################
# Iofogctl to install iofog and configure agents 
#############################################################
module "iofogctl" {
    source  = "../../modules/iofogctl"

    project_id                  = "${var.project_id}"
    cluster_name                = "${module.kubernetes.name}"
    region                      = "${module.kubernetes.region}"
    operator_image              = "${var.operator_image}"
    kubelet_image               = "${var.kubelet_image}"
    controller_image            = "${var.controller_image}"
    connector_image             = "${var.connector_image}"
    controller_ip               = "${var.controller_ip}"
    ssh_key                     = "${var.ssh_key}"
    iofogUser_name              = "${var.iofogUser_name}"
    iofogUser_surname           = "${var.iofogUser_surname}"
    iofogUser_email             = "${var.iofogUser_email}"
    iofogUser_password          = "${var.iofogUser_password}"
    namespace                   = "${var.iofogctl_namespace}"
    agent_repo                  = "${var.agent_repo}"
    agent_version               = "${var.agent_version}"
    agent_list                  = "${var.agent_list}"
    template_path               = "${file("../../environments_gke/iofogctl_inventory.tpl")}"
}