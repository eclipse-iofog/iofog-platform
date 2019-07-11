# Dev variables
project_id          = "<your-gcp-project-id>"
environment         = "<your-environment-name>" # Pick any name you like. Can only contain lowercase letters, numbers and hyphens and must start with a letter.
gcp_region          = "us-west2"
gcp_service_account = "<gcp-service-account-name>" # Something in the vein of <service-name>@<project-id>.iam.gserviceaccount.com

# ioFog vars
controller_ip       = "" # Static ip for loadbalancer, eompty is fine

# ioFog images
controller_image    = "iofog/controller:1.1.1"
connector_image     = "iofog/connector:1.1.0"
operator_image      = "iofog/iofog-operator:1.0.0"
kubelet_image       = "iofog/iofog-kubelet:1.0.0"

# Packet sample config used to setup and arm or x86 edge nodes to your controller
packet_project_id   = "<your-packet-project-id>"
operating_system    = "ubuntu_16_04"
packet_facility     = ["sjc1", "ewr1"]             
count_x86           = "1"
plan_x86            = "c1.small.x86"
count_arm           = "0"
plan_arm            = "c2.large.arm"

# Used by ansible for agent configuration on packet
ssh_key             = "~/.ssh/id_ecdsa"

# ioFog user vars (used to configure controller and agents)
iofogUser_name      = "iofog"
iofogUser_surname   = "edgeworx"          
iofogUser_email     = "user@domain.com"
iofogUser_password  = "#Bugs4Fun"

# iofogctl vars
iofogctl_namespace  = "iofog"

# List of edge nodes to install and configure agents on
agent_list = 
[{
    name = "<AGENT_NAME>",
    user = "<AGENT_USER>",
    host = "<AGENT_IP>",
    port = "<SSH_PORT>",
    keyfile = "<PRIVATE_SSH_KEY>"
}]