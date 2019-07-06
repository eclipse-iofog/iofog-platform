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

prettyHeader "GKE ioFog stack status"

prettyTitle "Pods"
kubectl get pods -n iofog -o wide
echo ""


prettyTitle "Services"
kubectl get svc -n iofog
echo ""