#!/bin/sh

. config.sh

TERRAFORM_FOLDER="./infrastructure/environments_gke/user"
VARS_FILE="$TERRAFORM_FOLDER"/user_vars.tfvars

> "$VARS_FILE"

function ChangeVar(){
    VAR="$1"
    VAL="$2"
    [ -z "$3" ] && VAL=\""$VAL"\"
    echo "$VAR"="$VAL" >> "$VARS_FILE"
}

ChangeVar "${!project_id@}" "$project_id"
ChangeVar "${!environment@}" "$environment"
ChangeVar "${!gcp_region@}" "$gcp_region"
ChangeVar "${!gcp_service_account@}" "$gcp_service_account"
ChangeVar "${!controller_ip@}" "$controller_ip"
ChangeVar "${!packet_project_id@}" "$packet_project_id"
ChangeVar "${!operating_system@}" "$operating_system"
ChangeVar "${!packet_facility@}" "$packet_facility" "no-quotation-marks"
ChangeVar "${!count_x86@}" "$count_x86"
ChangeVar "${!plan_x86@}" "$plan_x86"
ChangeVar "${!count_arm@}" "$count_arm"
ChangeVar "${!plan_arm@}" "$plan_arm"
ChangeVar "${!ssh_key@}" "$ssh_key"
ChangeVar "${!iofogUser_name@}" "$iofogUser_name"
ChangeVar "${!iofogUser_surname@}" "$iofogUser_surname"
ChangeVar "${!iofogUser_email@}" "$iofogUser_email"
ChangeVar "${!iofogUser_password@}" "$iofogUser_password"
ChangeVar "${!iofogctl_namespace@}" "$iofogctl_namespace"
ChangeVar "${!agent_repo@}" "$agent_repo"
ChangeVar "${!agent_version@}" "$agent_version"

export PACKAGE_CLOUD_TOKEN="$package_cloud_auth_token"
export PACKET_AUTH_TOKEN="$packet_auth_token"
export GOOGLE_APPLICATION_CREDENTIALS="$path_to_gcp_service_account_file"