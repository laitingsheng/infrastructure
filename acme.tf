resource "acme_registration" "main" {
  account_key_algorithm   = "ECDSA"
  account_key_ecdsa_curve = "P384"
  email_address           = "acme@${var.domain}.io"
}

resource "random_password" "p12" {
  length      = 64
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
  min_special = 1

  keepers = {
    year = formatdate("YYYY", plantimestamp())
  }
}

resource "acme_certificate" "apex" {
  for_each = azurerm_dns_zone.apex

  account_key_pem               = acme_registration.main.account_key_pem
  common_name                   = each.value.name
  key_type                      = "P384"
  min_days_remaining            = 40
  certificate_p12_password      = random_password.p12.result
  profile                       = "tlsserver"
  revoke_certificate_on_destroy = true
  revoke_certificate_reason     = "superseded"

  subject_alternative_names = [
    each.value.name,
    "*.${each.value.name}",
  ]

  dns_challenge {
    provider = "azuredns"

    config = {
      AZURE_RESOURCE_GROUP = azurerm_resource_group.connectivity.name
      AZURE_ZONE_NAME      = each.value.name
    }
  }
}
