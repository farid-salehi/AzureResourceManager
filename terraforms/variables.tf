variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "RG-Dev-USA-East"
}

variable "location" {
  description = "Azure region for the Resource Group"
  type        = string
  default     = "East US"
}

variable "aks_sc" {
  description = "AKS Cluster Service Connetion"
  type        = string
}

variable "acr" {
  description = "Azure Container Registry Name"
  type        = string
}