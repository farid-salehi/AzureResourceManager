resource "azurerm_user_assigned_identity" "workload_identity" {
  name                = "default-mid"
  resource_group_name = azurerm_resource_group.rg_dev_usa_east.name
  location            = azurerm_resource_group.rg_dev_usa_east.location
}

resource "azurerm_role_assignment" "appconfig_access" {
  scope                = azurerm_app_configuration.appconfig.id
  role_definition_name = "App Configuration Data Owner" 
  principal_id         = azurerm_user_assigned_identity.secure_api_workload_identity.principal_id
}

data "azurerm_kubernetes_cluster" "aks_data" {
  name                = azurerm_kubernetes_cluster.aks.name
  resource_group_name = azurerm_kubernetes_cluster.aks.resource_group_name
}