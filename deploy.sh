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

# Copy user terraform vars
cp ./my_vars.tfvars ./infrastructure/environments_gke/user/user_vars.tfvars
# Set current working dir to the terraform gke environment user
cd ./infrastructure/environments_gke/user/

terraform init
terraform plan -var-file="user_vars.tfvars"
terraform apply -var-file="user_vars.tfvars" -auto-approve