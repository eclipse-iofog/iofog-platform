# Cloud provider
# How to generate a gcloud service account json file: https://cloud.google.com/iam/docs/creating-managing-service-account-keys
google_application_credentials  = "<path-to-google-service-account-json>"

# Dev variables
project_id              = "<your-gcp-project-id>"
environment             = "<your-environment-name>" # Pick any name you like. Can only contain lowercase letters, numbers and hyphens and must start with a letter.
gcp_region              = "us-west2"
gcp_service_account     = "<gcp-service-account-name>" # Something in the vein of <service-name>@<project-id>.iam.gserviceaccount.com
    
# ioFog vars    
controller_ip           = "" # Static ip for loadbalancer, eompty is fine
    
# ioFog images  
controller_image        = "iofog/controller:1.1.1"
connector_image         = "iofog/connector:1.1.0"
operator_image          = "iofog/iofog-operator:1.0.0"
kubelet_image           = "iofog/iofog-kubelet:1.0.0"
    
    
# ioFog user vars (u    sed to configure controller and agents)
iofogUser_name          = "iofog"
iofogUser_surname       = "edgeworx"          
iofogUser_email         = "user@domain.com"
iofogUser_password      = "#Bugs4Fun"
    
# iofogctl vars (htt    ps://github.com/eclipse-iofog/iofogctl)
iofogctl_namespace      = "iofog"

# List of edge nodes to install and configure agents on
agent_list = 
[
    # Agent example
    # {
    #     name = "<AGENT_NAME>", # Name used to register the agent with the controller
    #     user = "<AGENT_USER>", # User name for ssh connection into the resource
    #     host = "<AGENT_IP>", # host for ssh connection into the resource
    #     port = "<SSH_PORT>", # port for ssh connection into the resource
    #     keyfile = "<PRIVATE_SSH_KEY>" # Absolute path to the private key used to ssh into the resource
    # },
]

# Uncomment this out if you want to use packet nodes as agents
# Packet sample config used to setup and arm or x86 edge nodes to your controller
# packet_auth_token     = "<your-packet-auth-token>" # How to generate: https://support.packet.com/kb/articles/api-integrations
# packet_project_id     = "<your-packet-project-id>"
# operating_system      = "ubuntu_16_04"
# packet_facility       = ["sjc1", "ewr1"]             
# count_x86             = "1"
# plan_x86              = "c1.small.x86"
# count_arm             = "0"
# plan_arm              = "c2.large.arm"
# ssh_key               = "~/.ssh/id_ecdsa"