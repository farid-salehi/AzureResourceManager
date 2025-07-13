# Create a resource group in Azure using a variable for the name and location
resource "azurerm_resource_group" "rg_dev_usa_east" {
 name     = var.resource_group_name   # Reference to variable for RG name
 location = var.location              # Reference to variable for Azure region
}