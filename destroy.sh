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
    echoInfo "Usage: `basename $0` variables_file.tfvars"
    echoInfo "       `basename $0` [-h, --help]"
    echoInfo "$0 will destroy minimal infrastructure: VPC, GKE, Packet nodes"
}

if [[ "${1-}" == "--help" ]] || [[ "${1-}" == "-h" ]]; then
  usage
  exit 0
fi

if [[ ! -r "${1-}" ]]; then
    echoError "Variables file \"${1-}\" does not exist!"
    usage
    exit 1
fi
TFVARS=$(realpath "${1-}")

prettyHeader "Destroying infrastructure"
echoInfo "Using ${TFVARS} as variable file"

cd "infrastructure/gcp"

if ! terraform destroy -var-file="${TFVARS}" -auto-approve ; then
    echoError "Terraform destroy failed."
    exit 1
fi

rm -f ecn.yaml

echoSuccess "Infrastructure successfully destroyed!"
