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

. ./scripts/utils.sh

# Export user credentials
. ./my_credentials.env

prettyHeader "Deploying GKE ioFog stack..."

echoInfo "Using ./my_vars.tfvars as variable file"
echoInfo "Using ./my_credentials.env to export credentials"
echo "$GOOGLE_APPLICATION_CREDENTIALS"


# Copy user terraform vars
cp ./my_vars.tfvars ./infrastructure/environments_gke/user/user_vars.tfvars
# Set current working dir to the terraform gke environment user
cd ./infrastructure/environments_gke/user/

displayError() {
  echoError "Something went wrong with your terraform deployment. Please find more informations in the logs above."
  exit 1
}

connectIofogctl() {
  
}

terraform init
if [[ $? -eq 0 ]]; then
  terraform plan -var-file="user_vars.tfvars"
else
  displayError
fi
if [[ $? -eq 0 ]]; then
  terraform apply -var-file="user_vars.tfvars" -auto-approve
else
  displayError
fi
if [[ $? -eq 0 ]]; then
  echo ""
  echoSuccess "You are done !"
  ./status.sh
  connectIofogctl
else
  displayError
fi
