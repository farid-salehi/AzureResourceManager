terraform {
  backend "azurerm" {
    # The name of the Azure Resource Group containing the storage account
    resource_group_name   = "RG-DEFAULT-USA-EAST"

    # The name of the Azure Storage Account where the Terraform state will be stored
    storage_account_name  = "stgdefaultusaeast"

    # The name of the blob container inside the storage account to hold the state file
    container_name        = "tfstate"

    # The path (key) within the container where the state file will be saved
    # Using a subfolder "stage" to isolate the state for this environment (stage)
    key                   = "stage/azresourcemanager.tfstate"
  }
}
