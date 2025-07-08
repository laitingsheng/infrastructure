terraform {
  required_version = "~> 1.0"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  backend "azurerm" {
    use_azuread_auth = true
    use_cli          = true
    environment      = "public"
  }
}

provider "azuread" {
  use_cli     = true
  environment = "public"
}

provider "azurerm" {
  use_cli                         = true
  environment                     = "public"
  resource_provider_registrations = "extended"
  storage_use_azuread             = true

  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }

    subscription {
      prevent_cancellation_on_destroy = true
    }
  }
}

data "azuread_client_config" "main" {}

data "azurerm_client_config" "main" {}

resource "azurerm_subscription" "main" {
  subscription_name = "foundation"
  alias             = "foundation"
  subscription_id   = data.azurerm_client_config.main.subscription_id
}

data "azurerm_subscription" "main" {
  subscription_id = data.azurerm_client_config.main.subscription_id
}

resource "azurerm_resource_group" "connectivity" {
  name     = "rg-connectivity-ea"
  location = "eastasia"
}

resource "azurerm_resource_group" "tfstate" {
  name     = "rg-tfstate-ea"
  location = "eastasia"
}
