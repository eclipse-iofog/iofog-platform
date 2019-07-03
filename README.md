# ioFog Platform

ioFog Platform provides a means by which to spin up and deploy an Eclipse ioFog stack on GKE and Packet.

# Requirements

* Gcloud SDK
* Terraform (v0.11.x)
* Ansible
* gcloud
* Kubectl
* Iofogctl

You can run `./bootstrap.sh` in order to download thoses dependencies.

You will also require the following environment variables
```sh
export PACKAGE_CLOUD_TOKEN=<package_cloud_token> # If you need to download private packages from packagecloud
export PACKET_AUTH_TOKEN=<packet_auth_token> # If you want to deploy agents on Packet
export GOOGLE_APPLICATION_CREDENTIALS=<path-to-json>
```
You can edit the file `./scripts/credentials.sh` to provide your keys.