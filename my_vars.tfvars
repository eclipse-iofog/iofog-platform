# Dev variables
project_id          = "focal-freedom-236620"
environment         = "papatodd"
gcp_region          = "us-central1"
gcp_service_account = "azure-gcr@focal-freedom-236620.iam.gserviceaccount.com"

# iofog vars
controller_ip       = "" # Static ip for loadbalancer, empty is fine.

# iofog images
controller_image    = "iofog/controller:1.1.1"
connector_image     = "iofog/connector:1.1.0"
operator_image      = "iofog/iofog-operator:1.0.0"
kubelet_image       = "iofog/iofog-kubelet:1.0.0"

# packet sample vars used to setup edge nodes in arm or x86
packet_project_id   = "880125b9-d7b6-43c3-99f5-abd1af3ce879"
operating_system    = "ubuntu_16_04"
packet_facility     = ["sjc1", "ewr1"]             
count_x86           = "1"
plan_x86            = "c1.small.x86"
count_arm           = "0"
plan_arm            = "c2.large.arm"

# used by ansible for agent configuration on packet
ssh_key             = "~/.ssh/iofog_rsa"

# iofog user vars
iofogUser_name      = "Papa"
iofogUser_surname   = "Todd"
iofogUser_email     = "user@domain.com"
iofogUser_password  = "#Bugs4Fun"

# iofogctl vars
iofogctl_namespace  = "default"

agent_list =
[/*{
  name = "Nano",
  user = "nvidia",
  host = "192.168.86.41",
  port = "22",
  keyfile = "~/.ssh/iofog_rsa"
},*/
{
  name = "ManorPi",
  user = "pi",
  host = "192.168.86.41",
  port = "22",
  keyfile = "~/.ssh/iofog_rsa"
}]