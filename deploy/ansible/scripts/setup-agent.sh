#!/usr/bin/env bash
CONTROLLER_HOST=$1

token=""
uuid=""

function login() {
    login=$(curl --request POST \
        --url $CONTROLLER_HOST/user/login \
        --header 'Content-Type: application/json' \
        --data '{"email":"user@domain.com","password":"#Bugs4Fun"}')
    token=$(echo $login | jq -r .accessToken)
}


function create-node() {
    node=$(curl --request POST \
        --url $CONTROLLER_HOST/iofog \
        --header "Authorization: $token" \
        --header 'Content-Type: application/json' \
        --data '{"name":"agent-smith","fogType":0}')
    uuid=$(echo $node | jq -r .uuid)
}

function provision() {
    provisioning=$(curl --request GET \
        --url $CONTROLLER_HOST/iofog/$uuid/provisioning-key \
        --header "Authorization: $token" \
        --header 'Content-Type: application/json')
    key=$(echo $provisioning | jq -r .key)

    iofog-agent provision $key
}


# These are our setup steps
login
create-node
provision
