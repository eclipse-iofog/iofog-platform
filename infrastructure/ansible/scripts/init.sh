#!/usr/bin/env bash
CONTROLLER_HOST=$1
AGENT_NAME=$2
USER_EMAIL=$3
USER_PASSWORD=$4

token=""
uuid=""

function login() {
    echo "Logging in"
    login=$(curl --request POST \
        --url $CONTROLLER_HOST/user/login \
        --header 'Content-Type: application/json' \
        --data "{\"email\":\"${USER_EMAIL}\",\"password\":\"${USER_PASSWORD}\"}")
    echo "$login"
    token=$(echo $login | jq -r .accessToken)
}

function create-node() {
    echo "Creating node"
    node=$(curl --request POST \
        --url $CONTROLLER_HOST/iofog \
        --header "Authorization: $token" \
        --header 'Content-Type: application/json' \
        --data '{"name": '\"$AGENT_NAME\"' ,"fogType":0}')
    echo "$node"
    uuid=$(echo $node | jq -r .uuid)
}

function provision() {
    echo "Provisioning key"
    provisioning=$(curl --request GET \
        --url $CONTROLLER_HOST/iofog/$uuid/provisioning-key \
        --header "Authorization: $token" \
        --header 'Content-Type: application/json')
    echo "$provisioning"
    key=$(echo $provisioning | jq -r .key)

    iofog-agent provision $key
}

# These are our setup steps
login
create-node
provision
