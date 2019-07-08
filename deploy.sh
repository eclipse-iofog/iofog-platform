#!/bin/bash
#
# *******************************************************************************
#  * Copyright (c) 2019 Edgeworx, Inc.
#  *
#  * This program and the accompanying materials are made available under the
#  * terms of the Eclipse Public License v. 2.0 which is available at
#  * http://www.eclipse.org/legal/epl-2.0
#  *
#  * SPDX-License-Identifier: EPL-2.0
#  *******************************************************************************
#

#
# Print out our usage
#
. ./scripts/utils.sh

usage() {
    echo
    echoInfo "Usage: `basename $0` [-h, --help]"
    echoInfo "$0 will deploy a GKE ioFog stack using terraform and connect to it using iofogctl"
    exit 0
}

if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
  usage
fi


# Export user credentials
. ./my_credentials.env

prettyHeader "Deploying GKE ioFog stack..."

echoInfo "Using ./my_vars.tfvars as variable file"
echoInfo "Using ./my_credentials.env to export credentials"

# Copy user terraform vars
cp ./my_vars.tfvars ./infrastructure/environments_gke/user/user_vars.tfvars
# Set current working dir to the terraform gke environment user
cd ./infrastructure/environments_gke/user/

displayError() {
  echoError "Something went wrong with your terraform deployment. Please find more information in the logs above."
  exit 1
}

# connectIofogctl() {
#   IOFOGCTL_USER=$(cat ./my_vars.tfvars | grep 'iofogUser_email' | awk '{print $3}')
#   IOFOGCTL_PWD=$(cat ./my_vars.tfvars | grep 'iofogUser_password' | awk '{print $3}')
#   IOFOGCTL_PWD=$(kubectl get svc -n iofog | grep 'connector' | awk '{print $4}')
#   echo $IOFOGCTL_USER
#   echo $PWD
#   echo $CONTROLLER_IP
#   NAMESPACE=$1
#   NAMESPACE="${NAMESPACE:-default}"
#   iofogctl -n "$NAMESPACE" connect GKE_Controller --controller "$CONTCONTROLLER_IPRO:51121" --email "$IOFOGCTL_USER" --pass "$IOFOGCTL_PWD"
#   iofogctl -n "$NAMESPACE" get all 
# }
 
{
  terraform init
} || {
  displayError
}
{
  terraform plan -var-file="user_vars.tfvars"
} || {
  displayError
}
{
  terraform apply -var-file="user_vars.tfvars" -auto-approve
} || {
  displayError
}

echo ""
echoSuccess "You are done !"
cd - > /dev/null
. ./status.sh

NAMESPACE=$(cat ./my_vars.tfvars | grep 'iofogctl_namespace' | awk '{print $3}')
iofogctl -n $NAMESPACE get all