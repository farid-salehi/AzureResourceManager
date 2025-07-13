resource "azurerm_app_configuration" "appconfig" {
  name                = "appconfig-dev-usaeast"  
  resource_group_name = azurerm_resource_group.rg_dev_usa_east.name
  location            = azurerm_resource_group.rg_dev_usa_east.location
  sku                 = "free"    
}