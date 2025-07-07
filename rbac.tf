resource "azurerm_role_assignment" "subscription-main" {
  for_each = toset([
    "Contributor",
    "Storage Blob Data Contributor",
  ])

  scope                = data.azurerm_subscription.main.id
  role_definition_name = each.key
  principal_id         = azuread_service_principal.devops.object_id
  principal_type       = "ServicePrincipal"
}
