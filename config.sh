#!/bin/sh

# Cloud service credentials
package_cloud_auth_token=""      # If you need to download private packages from packagecloud
packet_auth_token=""        # If you want to deploy agents on Packet
path_to_gcp_service_account_file="" # Path to JSON file

# Dev variables
project_id="focal-freedom-236620"
environment="any-name-will-do"
gcp_region="us-west2"
gcp_service_account="iofog-platform@focal-freedom-236620.iam.gserviceaccount.com" # Something in the vein of <service-name>@<project-id>.iam.gserviceaccount.com

# iofog vars
controller_ip="" # Static ip for loadbalancer, empty is fine.
# iofog images
controller_image="iofog/controller:1.1.1"
connector_image="iofog/connector:1.1.0"
operator_image="iofog/iofog-operator:1.0.0"
kubelet_image="iofog/iofog-kubelet:1.0.0"

#packet sample vars used to setup edge nodes in arm or x86
packet_project_id="880125b9-d7b6-43c3-99f5-abd1af3ce879"
operating_system="ubuntu_16_04"
packet_facility='["sjc1", "ewr1"]'
count_x86="1"
plan_x86="c1.small.x86"
count_arm="0"
plan_arm="c2.large.arm"
# used by ansible for agent configuration on packet
ssh_key="~/.ssh/id_ecdsa"

# iofog user vars
iofogUser_name="iofog"
iofogUser_surname="edgeworx"          
iofogUser_email="user@domain.com"
iofogUser_password="#Bugs4Fun"

# iofogctl vars
iofogctl_namespace="iofog"

# You will need to export the agent snapshot package cloud token as env var(PACKAGE_CLOUD_CREDS) to access the dev repo
agent_repo="dev" 
agent_version="1.1.0-b2002"