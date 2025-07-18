terraform {
  required_version = "~> 1.0"

  required_providers {
    acme = {
      source  = "vancluever/acme"
      version = "~> 2.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }

    namecheap = {
      source  = "namecheap/namecheap"
      version = "~> 2.0"
    }
  }

  backend "azurerm" {
    use_azuread_auth     = true
    storage_account_name = "sabaseea"
    container_name       = "tfstate"
  }
}

provider "azuread" {}

provider "azurerm" {
  resource_provider_registrations = "extended"
  storage_use_azuread             = true

  features {
    cognitive_account {
      purge_soft_delete_on_destroy = false
    }

    key_vault {
      purge_soft_delete_on_destroy               = false
      purge_soft_deleted_certificates_on_destroy = false
      purge_soft_deleted_keys_on_destroy         = false
      purge_soft_deleted_secrets_on_destroy      = false
      recover_soft_deleted_certificates          = true
      recover_soft_deleted_keys                  = true
      recover_soft_deleted_secrets               = true
    }

    resource_group {
      prevent_deletion_if_contains_resources = false
    }

    subscription {
      prevent_cancellation_on_destroy = false
    }
  }
}

provider "cloudflare" {}

provider "namecheap" {
  user_name   = var.github.username
  api_user    = var.github.username
  use_sandbox = false
}

data "azuread_client_config" "main" {}

data "azurerm_client_config" "main" {}

data "azurerm_billing_mca_account_scope" "main" {
  billing_account_name = var.mca.account
  billing_profile_name = var.mca.profile
  invoice_section_name = var.mca.invoice
}

resource "azurerm_subscription" "main" {
  subscription_name = "foundation"
  alias             = "foundation"
  billing_scope_id  = data.azurerm_billing_mca_account_scope.main.id

  lifecycle {
    prevent_destroy = true
  }
}

data "azurerm_subscription" "main" {
  subscription_id = azurerm_subscription.main.subscription_id
}

resource "azurerm_resource_group" "main" {
  name     = "rg-base-ea"
  location = "eastasia"

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_resource_group" "cognitive" {
  name     = "rg-cognitive-sea"
  location = "southeastasia"
}

resource "cloudflare_account" "main" {
  name = "foundation"
  type = "standard"

  settings = {
    abuse_contact_email = var.primary
    enforce_twofactor   = true
  }
}
