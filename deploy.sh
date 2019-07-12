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


prettyHeader "Deploying GKE ioFog stack..."

echoInfo "Using ./config.sh as variable file"

TERRAFORM_FOLDER="./infrastructure/environments_gke/user"

displayError() {
  echoError "Something went wrong with your terraform deployment. Please find more information in the logs above."
  exit 1
}

# Create var file
. ./scripts/set_vars.sh

# Generate main.tf file
. ./scripts/generate_terraform_main.sh

# Set current working dir to the terraform gke environment user
cd "$TERRAFORM_FOLDER"

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
. ./scripts/status.sh