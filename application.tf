resource "azuread_application" "devops" {
  display_name            = "spn-devops"
  owners                  = []
  prevent_duplicate_names = true
  sign_in_audience        = "AzureADMyOrg"

  feature_tags {
    enterprise = true
    gallery    = false
    hide       = true
  }

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    resource_access {
      id   = "9a5d68dd-52b0-4cc2-bd40-abcf44ac3a30" # Application.Read.All
      type = "Role"
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "azuread_service_principal" "devops" {
  account_enabled = true
  client_id       = azuread_application.devops.client_id
  owners          = azuread_application.devops.owners

  feature_tags {
    enterprise = true
    gallery    = false
    hide       = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "azuread_application_federated_identity_credential" "devops" {
  application_id = azuread_application.devops.id
  audiences      = ["api://AzureADTokenExchange"]
  description    = "GitHub Actions"
  display_name   = "fic-github"
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = "repo:${var.github-repository}:environment:devops"

  lifecycle {
    prevent_destroy = true
  }
}
