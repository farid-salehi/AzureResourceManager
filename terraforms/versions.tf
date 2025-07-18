terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.40.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 3.0" 
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0" 
    }
  }
}