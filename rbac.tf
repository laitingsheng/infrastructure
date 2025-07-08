resource "azurerm_role_assignment" "alias-main" {
  scope                = azurerm_subscription.main.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.devops.object_id
  principal_type       = "ServicePrincipal"
}

resource "azurerm_role_assignment" "subscription-main" {
  for_each = toset([
    "Contributor",
    "Key Vault Certificates Officer",
    "Key Vault Crypto Officer",
    "Key Vault Secrets Officer",
    "Storage Blob Data Contributor",
  ])

  scope                = data.azurerm_subscription.main.id
  role_definition_name = each.key
  principal_id         = azuread_service_principal.devops.object_id
  principal_type       = "ServicePrincipal"
}
