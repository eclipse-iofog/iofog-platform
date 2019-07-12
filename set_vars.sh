#!/bin/sh

. config.sh

TERRAFORM_FOLDER="./infrastructure/environments_gke/user"
VARS_FILE="$TERRAFORM_FOLDER"/user_vars.tfvars

> "$VARS_FILE"

function AddVar(){
    if [ ! -z "$1" ] && [ ! -z "$2" ]; then
        VAR="$1"
        VAL="$2"
        [ -z "$3" ] && VAL=\""$VAL"\"
        echo "$VAR"="$VAL" >> "$VARS_FILE"
    fi
}

AddVar "${!project_id@}" "$project_id"
AddVar "${!environment@}" "$environment"
AddVar "${!gcp_region@}" "$gcp_region"
AddVar "${!gcp_service_account@}" "$gcp_service_account"
AddVar "${!controller_ip@}" "$controller_ip"
AddVar "${!packet_project_id@}" "$packet_project_id"
AddVar "${!operating_system@}" "$operating_system"
AddVar "${!controller_image@}" "$controller_image"
AddVar "${!connector_image@}" "$connector_image"
AddVar "${!operator_image@}" "$operator_image"
AddVar "${!kubelet_image@}" "$kubelet_image"
AddVar "${!packet_facility@}" "$packet_facility" "no-quotation-marks"
AddVar "${!count_x86@}" "$count_x86"
AddVar "${!plan_x86@}" "$plan_x86"
AddVar "${!count_arm@}" "$count_arm"
AddVar "${!plan_arm@}" "$plan_arm"
AddVar "${!ssh_key@}" "$ssh_key"
AddVar "${!iofogUser_name@}" "$iofogUser_name"
AddVar "${!iofogUser_surname@}" "$iofogUser_surname"
AddVar "${!iofogUser_email@}" "$iofogUser_email"
AddVar "${!iofogUser_password@}" "$iofogUser_password"
AddVar "${!iofogctl_namespace@}" "$iofogctl_namespace"
AddVar "${!agent_repo@}" "$agent_repo"
AddVar "${!agent_version@}" "$agent_version"
AddVar "${!agent_list@}" "$agent_list" "no-quoatation-marks"

export PACKAGE_CLOUD_TOKEN="$package_cloud_auth_token"
export PACKET_AUTH_TOKEN="$packet_auth_token"
export GOOGLE_APPLICATION_CREDENTIALS="$path_to_gcp_service_account_file"