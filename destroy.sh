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
usage() {
    echo
    echoInfo "Usage: `basename $0` [-h, --help] [namespace]"
    echoInfo "$0 will destroy a GKE ioFog stack using terraform and try to disconnect it from iofogctl"
    echoInfo "If provided the namespace will be used when using iofogctl"
    exit 0
}
if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
  usage
fi

. ./scripts/utils.sh

# Export user credentials
. ./my_credentials.env



prettyHeader "Destroying GKE ioFog stack..."

echoInfo "Using ./my_vars.tfvars as variable file"
echoInfo "Using ./my_credentials.env to export credentials"
echo ""

# Copy user terraform vars
cp ./my_vars.tfvars ./infrastructure/environments_gke/user/user_vars.tfvars
# Set current working dir to the terraform gke environment user
cd ./infrastructure/environments_gke/user/

displayError() {
  echoError "Something went wrong with your terraform deployment. Please find more informations in the logs above."
  exit 1
}

cleanTerrformStateFiles() {
  rm -rf .terraform
  rm -rf *.tfstate*
  rm -rf iofogctl_inventory.yaml
}

disconnectIofogctl() {
  NAMESPACE=$1
  NAMESPACE="${NAMESPACE:-default}"
  {
    iofogctl -n "$NAMESPACE" disconnect GKE_Controller
  } || {
    echoInfo "Could not disconnect from iofogctl"
  }
}

 
{
  terraform init
} || {
  displayError
}
{
  terraform destroy -var-file="user_vars.tfvars" -auto-approve
} || {
  displayError
}
cleanTerrformStateFiles
disconnectIofogctl
echo ""
echoSuccess "You are done!"