SHELL = /bin/bash
OS = $(shell uname -s)

# Project variables
PACKAGE = github.com/iofog/iofog-platform

# Build variables
VERSION ?= $(shell git rev-parse --abbrev-ref HEAD)
COMMIT_HASH ?= $(shell git rev-parse --short HEAD 2>/dev/null)
BUILD_DATE ?= $(shell date +%FT%T%z)
K8S_VERSION ?= 1.13.4
MINIKUBE_VERSION ?= 0.35.0
COMPOSE=build/docker-compose.yml
COMPOSE_SVCS = iofog-agent-1 iofog-agent-2 iofog-controller iofog-connector iofog-kubelet

# Variable outputting/exporting rules
var-%: ; @echo $($*)
varexport-%: ; @echo $*=$($*)

# Install targets
.PHONY: install-kubectl
install-kubectl: # Install Kubernetes CLI
	curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/v$(K8S_VERSION)/bin/linux/amd64/kubectl
	chmod +x kubectl 
	sudo mv kubectl /usr/local/bin/

.PHONY: install-kind
install-kind: # Install Kubernetes in Docker
	go get sigs.k8s.io/kind

.PHONY: install-minikube
install-minikube: # Install Minikube
	curl -Lo minikube https://storage.googleapis.com/minikube/releases/v$(MINIKUBE_VERSION)/minikube-linux-amd64
	chmod +x minikube
	sudo mv minikube /usr/local/bin/

# Deployment targets
.PHONY: deploy-kind
deploy-kind: install-kubectl install-kind# Deploy Kubernetes locally with KinD
	kind create cluster

.PHONY: deploy-minikube
deploy-minikube: install-kubectl install-minikube # Deploy kubernetes locally with minikube
	sudo minikube start --vm-driver=none --kubernetes-version=v$(K8S_VERSION) --cpus 1 --memory 1024 --disk-size 2000m
	sudo minikube update-context

.PHONY: deploy-iofog
deploy-iofog: KUBECONFIG = $(shell kind get kubeconfig-path)
deploy-iofog: PORT = $(shell KUBECONFIG=$(KUBECONFIG) kubectl cluster-info | head -n 1 | cut -d ":" -f 3 | sed 's/[^0-9]*//g' | rev | cut -c 2- | rev)
deploy-iofog: # Deploy ioFog services
	docker-compose -f $(COMPOSE) pull
	docker-compose -f $(COMPOSE) build
	docker-compose -f $(COMPOSE) up --detach $(COMPOSE_SVCS)
	sed 's/<<PORT>>/"$(PORT)"/g' deploy/operator.yml.tmpl > deploy/operator.yml
	kubectl create -f deploy/operator.yml
	kubectl create -f deploy/scheduler.yml

# Test / push targets
.PHONY: test
test: # Run system tests against ioFog services
	@echo 'TODO: Write system tests :)'

.PHONY: push-iofog
push-iofog: # Push ioFog packages
	@echo 'TODO :)'
#	@echo $(DOCKER_PASS) | docker login -u $(DOCKER_USER) --password-stdin
#	for IMG in $(IOFOG_IMGS) ; do \
#		docker push $(IMAGE):$(TAG) ; \
#	done

# Clean up targets
.PHONY: rm-kind
rm-kind: # Remove KinD cluster
	kind delete cluster

.PHONY: rm-minikube
rm-minikube: # Remove Minikube cluster
	sudo minikube stop
	sudo minikube delete

.PHONY: rm-iofog
rm-iofog: KUBECONFIG = $(shell kind get kubeconfig-path)
rm-iofog: # Remove iofog services
	docker-compose -f $(COMPOSE) stop
	docker-compose -f $(COMPOSE) down
	kubectl delete -f deploy/operator.yml
	rm deploy/operator.yml
	kubectl delete -f deploy/scheduler.yml

# Utility targets
.DEFAULT_GOAL := help
.PHONY: help
help:
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: list
list: ## List all make targets
	@$(MAKE) -pRrn : -f $(MAKEFILE_LIST) 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | sort