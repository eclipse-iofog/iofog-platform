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
. ./my_credentials.sh

prettyHeader "Destroying GKE ioFog stack..."

echoInfo "Using ./my_vars.tfvars as variable file"
echoInfo "Using ./my_credentials.sh to export credentials"
echo ""

# Copy user terraform vars
cp ./my_vars.tfvars ./infrastructure/environments_gke/user/user_vars.tfvars
# Set current working dir to the terraform gke environment user
cd ./infrastructure/environments_gke/user/

terraform init
terraform destroy -var-file="user_vars.tfvars" -auto-approve

echo ""
echoSuccess "You are done!"