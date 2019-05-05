#!/bin/bash

set -e

OS=$(uname -s | tr A-Z a-z)
HELM_VERSION=2.13.1
K8S_VERSION=1.13.4

# Kubectl
curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/v"$K8S_VERSION"/bin/"$OS"/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

# Helm
curl -Lo helm.tar.gz https://storage.googleapis.com/kubernetes-helm/helm-v"$HELM_VERSION"-"$OS"-amd64.tar.gz
tar -xf helm.tar.gz
rm helm.tar.gz
sudo mv "$OS"-amd64/helm /usr/local/bin
chmod +x /usr/local/bin/helm
rm -r "$OS"-amd64

# jq
if [ "$OS" == "darwin" ]; then
	brew install jq
else
	sudo apt install jq
fi

# Ansible
pip install ansible==2.7.9
