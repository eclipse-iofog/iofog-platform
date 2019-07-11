#!/usr/bin/env sh

TERRAFORM_FOLDER="./infrastructure/environments_gke/user"
MAIN_TERRAFORM_TEMPLATE="main.tf.template"
PACKET_TEMPLATE="packet.tf.template"

cp "$TERRAFORM_FOLDER/$MAIN_TERRAFORM_TEMPLATE" "$TERRAFORM_FOLDER/main.tf"

if ! [[ -z ${PACKET_AUTH_TOKEN} ]]; then
  cat "$TERRAFORM_FOLDER/$PACKET_TEMPLATE" >> "$TERRAFORM_FOLDER/main.tf"
fi