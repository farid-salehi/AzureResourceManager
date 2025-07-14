resource "azurerm_user_assigned_identity" "default_app_managed_identity" {
  name                = local.default_app.managed_identity_name
  resource_group_name = azurerm_resource_group.rg_dev_usa_east.name
  location            = azurerm_resource_group.rg_dev_usa_east.location
}

resource "azurerm_role_assignment" "default_app_managed_identity_appconfig_access" {
  scope                = azurerm_app_configuration.appconfig.id
  role_definition_name = "App Configuration Data Owner" 
  principal_id         = azurerm_user_assigned_identity.default_app_managed_identity.principal_id
}

data "azurerm_kubernetes_cluster" "default_app_aks_data" {
  name                = azurerm_kubernetes_cluster.aks.name
  resource_group_name = azurerm_kubernetes_cluster.aks.resource_group_name
}

resource "azurerm_federated_identity_credential" "default_app_aks_federated_credential" {
  name                = local.default_app.federated_credential_name
  resource_group_name = azurerm_resource_group.rg_dev_usa_east.name
  parent_id           = azurerm_user_assigned_identity.default_app_managed_identity.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = data.azurerm_kubernetes_cluster.default_app_aks_data.oidc_issuer_url
  subject             = "system:serviceaccount:default:${local.default_app.service_account_name}"
}
