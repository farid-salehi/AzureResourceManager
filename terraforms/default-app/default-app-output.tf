output "default_app_managed_identity_client_id" {
  value = azurerm_user_assigned_identity.default_app_managed_identity.client_id
}

output "default_app_service_account_name" {
  value = local.default_app.service_account_name
}