#!/bin/bash

set -e

GCP_PROJ=focal-freedom-236620
PREFIX=plugins/gcp
# Ensure $USER is valid
# * google_container_cluster.gke: "name" can only contain lowercase letters, numbers and hyphens
USER_LC=`echo "$USER" | tr [':upper:'] [':lower:']` # To lower case
USER_HYPHENS=`echo "$USER_LC" | sed -e 's/[^a-z0-9-]//g'` # Remove all non alphanumeric or hyphen
export KUBECONFIG=conf/kube.conf

# Deploy infrastructure
terraform init "$PREFIX"/terraform/cluster
terraform apply -var user="$USER_HYPHENS" -var gcp_project="$GCP_PROJ" -auto-approve "$PREFIX"/terraform/cluster

# Wait for Kubernetes cluster
"$PREFIX"/script/wait-for-gke.bash $(terraform output name)

# Update conf/kube.conf
gcloud container clusters get-credentials $(terraform output name) --zone $(terraform output zone)