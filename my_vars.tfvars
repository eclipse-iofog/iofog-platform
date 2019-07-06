# Dev variables
project_id          = "focal-freedom-236620"
environment         = "tmp-alex"
gcp_region          = "us-west2"
gcp_service_account = "iofog-platform@focal-freedom-236620.iam.gserviceaccount.com"

# iofog vars
controller_ip       = "" # Static ip for loadbalancer, eompty is fine.
# iofog images
controller_image    = "iofog/controller:1.1.1"
connector_image     = "iofog/connector:1.1.0"
operator_image      = "iofog/iofog-operator:1.0.0"
kubelet_image       = "iofog/iofog-kubelet:1.0.0"

#packet sample vars used to setup edge nodes in arm or x86
packet_project_id   = "880125b9-d7b6-43c3-99f5-abd1af3ce879"
operating_system    = "ubuntu_16_04"
packet_facility     = ["sjc1", "ewr1"]             
count_x86           = "1"
plan_x86            = "c1.small.x86"
count_arm           = "0"
plan_arm            = "c2.large.arm"
# used by ansible for agent configuration on packet
ssh_key             = "~/.ssh/id_rsa"

# iofog user vars
iofogUser_name      = "iofog"
iofogUser_surname   = "edgeworx"          
iofogUser_email     = "user@domain.com"
iofogUser_password  = "#Bugs4Fun"

# iofogctl vars
iofogctl_namespace  = "iofog"

# You will need to export the agent snapshot package cloud token as env var(PACKAGE_CLOUD_CREDS) to access the dev repo
# uncomment these if using dev repo
# agent_repo          = "dev" 
# agent_version       = "1.0.14-b1245"
