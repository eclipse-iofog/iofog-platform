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
set -o errexit -o pipefail -o noclobber -o nounset

cd "$(dirname "$0")"

. ./scripts/utils.sh

usage() {
    echo
    echoInfo "Usage: `basename $0` [-h, --help] [--only-clean-state]"
    echoInfo "$0 will destroy a GKE ioFog stack using terraform."
    echoInfo "--only-clean-state will only clean the terraform state files."
    exit 0
}
if [[ "${1-}" == "--help" ]] || [[ "${1-}" == "-h" ]]; then
  usage
fi

cleanTerrformStateFiles() {
  rm -rf .terraform
  rm -rf *.tfstate*
  rm -rf iofogctl_inventory.yaml
}

if [[ "${1-}" == "--only-clean-state" ]]; then
  prettyHeader "Deleting terraform state"
  cd ./infrastructure/environments_gke/user/
  cleanTerrformStateFiles
  echoSuccess "You are done!"
  exit 0
fi

prettyHeader "Destroying GKE ioFog stack..."

echoInfo "Using ./my_vars.tfvars as variable file"
echo ""

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
  NAMESPACE=$(cat ./user_vars.tfvars | grep iofogctl_namespace | awk '{print $3}' | tr -d \")
  NAMESPACE="${NAMESPACE:-iofog}"
  {
    iofogctl -n $NAMESPACE disconnect
  } || {
    echoInfo "Could not disconnect from iofogctl"
  }
}

# Copy user terraform vars
cp ./my_vars.tfvars ./infrastructure/environments_gke/user/user_vars.tfvars

# Generate main.tf file
. ./scripts/generate_terraform_main.sh

# Set current working dir to the terraform gke environment user
cd ./infrastructure/environments_gke/user/

{
  terraform init
} || {
  displayError
} 
{
  disconnectIofogctl
} || {
  displayError
}
{
  terraform destroy -var-file="user_vars.tfvars" -auto-approve
} || {
  displayError
}
cleanTerrformStateFiles
echo ""
echoSuccess "You are done!"