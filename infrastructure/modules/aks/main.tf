#############################################################
# Setup AKS cluster on Azure
#############################################################
variable "environment" {
    description = "A prefix used for all resources in this example"
}

variable "azure_region" {
    description = "The Azure Region in which all resources in this example should be provisioned"
}

variable "aks_client_id" {
    description = "The Client ID for the Service Principal to use for this Managed Kubernetes Cluster"
}

variable "aks_client_secret" {
    description = "The Client Secret for the Service Principal to use for this Managed Kubernetes Cluster"
}

provider "azurerm" {
    version             = "=1.31.0"
}

resource "azurerm_resource_group" "resource-group" {
    name                = "${var.environment}-k8s-resources"
    location            = "${var.azure_region}"
}

resource "azurerm_kubernetes_cluster" "aks" {
    name                = "${var.environment}-k8s"
    location            = "${azurerm_resource_group.resource-group.location}"
    resource_group_name = "${azurerm_resource_group.resource-group.name}"
    dns_prefix          = "${var.environment}-k8s"

    agent_pool_profile {
        name            = "default"
        count           = 3
        vm_size         = "Standard_D1_v2"
        os_type         = "Linux"
        os_disk_size_gb = 30
    }

    service_principal {
        client_id       = "${var.aks_client_id}"
        client_secret   = "${var.aks_client_secret}"
    }
}