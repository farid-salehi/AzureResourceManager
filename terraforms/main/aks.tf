resource "azurerm_kubernetes_cluster" "aks" {
  name                = "dev-aks-cluster"
  resource_group_name = azurerm_resource_group.rg_dev_usa_east.name
  location            = azurerm_resource_group.rg_dev_usa_east.location
  dns_prefix          = "faidsalehi"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B2s"
  }

  identity {
    type = "SystemAssigned"
  }

  role_based_access_control_enabled = true
  oidc_issuer_enabled               = true
  workload_identity_enabled         = true
}
