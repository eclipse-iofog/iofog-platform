import os
import sys
import json
import subprocess
import requests

catalog_ids = []


def bash_cmd(bashCommand):
    process = subprocess.Popen(bashCommand.split(), stdout=subprocess.PIPE)
    output, error = process.communicate()

    return output

DOCKER_IMAGES = (
    "image-service" "device-service" "detection-service" "command-service" "livestream" "user-service" "video-service" "web-service")

def setup_user():
    bash_cmd("iofog-controller user add --email 'test@edgeworx.io' --first-name 'Test' --last-name 'Name' --password 'test'")
    command = "iofog-controller user list | grep id | awk 'NR==1 {print $2}'"
    user = bash_cmd(command)
    user = user[:-1]

    return user

def get_prov_token(prov_key):

    url = 'http://localhost/api/v3/agent/provision'
    data = {"provisioning_key": "{}".format(prov_key)}

    response = requests.post(url, data=data)
    return response

def get_prov_key(user, iteration):
    command = "iofog-controller iofog add --name AGENT{} --fog-type 0 -u {} | grep uuid | awk -F  ':' '{print $2}'".format(iteration, name)
    prov_key = bash_cmd(command)
    prov_key = prov_key[3:-2]

    return get_prov_token(prov_key)

def main():
    user = setup_user()
    tag = "release"
    prov_tokens = []

    for i in range(len(DOCKER_IMAGES)):
        docker_image_name = "eddgeworx/jrc-1-{}".format(DOCKER_IMAGES[i])
        command = "iofog-controller catalog add --name {} --x86-image={}:{} --registry-id 1 --user-id \
                                {} --category 'some-category'".format(DOCKER_IMAGES[i], docker_image_name, tag, user)

        catalog_id = bash_cmd(command)
        prov_token = get_prov_key(user, i)
        catalog_ids.append(catalog_id)
        prov_tokens.append(prov_token)


