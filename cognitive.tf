resource "azurerm_cognitive_account" "openai" {
  name                               = "acsa-openai-sea"
  resource_group_name                = azurerm_resource_group.cognitive.name
  location                           = azurerm_resource_group.cognitive.location
  kind                               = "OpenAI"
  sku_name                           = "S0"
  fqdns                              = []
  local_auth_enabled                 = false
  outbound_network_access_restricted = true
  public_network_access_enabled      = true
}
