output "secure_api_managed_identity_client_id" {
  value = azurerm_user_assigned_identity.secure_api_managed_identity.client_id
}

output "secure_api_service_account_name" {
  value = local.secure_api.service_account_name
}