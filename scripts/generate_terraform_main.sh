#!/usr/bin/env sh

TERRAFORM_FOLDER="./infrastructure/environments_gke/user"
MAIN_TERRAFORM_TEMPLATE="main.tf.template"
PACKET_TEMPLATE="packet.tf.template"

cp "$TERRAFORM_FOLDER/$MAIN_TERRAFORM_TEMPLATE" "$TERRAFORM_FOLDER/main.tf"

# Check value of not commented 'packet_auth_token' variable
# grep packet_auth_token, trim space and tabs, ignore lines commencing with #, split using =, get second value, trim "
ENABLE_PACKET=$(cat $TERRAFORM_FOLDER/user_vars.tfvars | grep 'packet_auth_token' |  tr -d " " | tr -d "\t" | grep -v '^[#]' | awk -F '=' '{print $2}' | tr -d \" | grep -v '^[#]')

if ! [[ -z $ENABLE_PACKET ]]; then
  cat "$TERRAFORM_FOLDER/$PACKET_TEMPLATE" >> "$TERRAFORM_FOLDER/main.tf"
fi