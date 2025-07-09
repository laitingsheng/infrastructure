resource "azurerm_key_vault" "main" {
  name                            = "kv-base-ea"
  location                        = azurerm_resource_group.main.location
  resource_group_name             = azurerm_resource_group.main.name
  sku_name                        = "standard"
  tenant_id                       = data.azurerm_client_config.main.tenant_id
  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true
  enable_rbac_authorization       = true
  purge_protection_enabled        = true
  public_network_access_enabled   = true
  soft_delete_retention_days      = 30
}

resource "azurerm_key_vault_certificate_contacts" "main" {
  key_vault_id = azurerm_key_vault.main.id

  contact {
    email = "expiry@${var.apex.name}.io"
  }
}

resource "azurerm_key_vault_certificate" "apex-io" {
  name         = "${var.apex.name}-io-wildcard"
  key_vault_id = azurerm_key_vault.main.id

  certificate_policy {
    issuer_parameters {
      name = "Unknown"
    }

    key_properties {
      key_type   = "RSA"
      key_size   = "4096"
      exportable = true
      reuse_key  = false
    }

    lifetime_action {
      action {
        action_type = "EmailContacts"
      }

      trigger {
        days_before_expiry = 30
      }
    }

    secret_properties {
      content_type = "application/x-pem-file"
    }

    x509_certificate_properties {
      key_usage = [
        "cRLSign",
        "digitalSignature",
        "keyAgreement",
        "keyCertSign",
        "nonRepudiation",
      ]

      extended_key_usage = [
        "1.3.6.1.5.5.7.3.1", # TLS Web Server Authentication
        "1.3.6.1.5.5.7.3.2", # TLS Web Client Authentication
        "1.3.6.1.5.5.7.3.8", # Time Stamping
      ]

      subject = "CN=*.${var.apex.name}.io"

      subject_alternative_names {
        dns_names = [
          "*.${var.apex.name}.io",
          "${var.apex.name}.io",
        ]
      }

      validity_in_months = 12
    }
  }
}

data "azurerm_key_vault_secret" "acme-eab-key-id" {
  key_vault_id = azurerm_key_vault.main.id
  name         = "zerossl-acme-eab-key-id"
}

data "azurerm_key_vault_secret" "acme-eab-hmac" {
  key_vault_id = azurerm_key_vault.main.id
  name         = "zerossl-acme-eab-hmac"
}

resource "azurerm_key_vault_certificate" "apex" {
  for_each = var.apex.suffices

  name         = "${var.apex.name}-${each.key}-wildcard"
  key_vault_id = azurerm_key_vault.main.id

  certificate {
    contents = join("\n", [
      acme_certificate.apex[each.key].certificate_pem,
      acme_certificate.apex[each.key].issuer_pem,
      tls_private_key.csr.private_key_pem_pkcs8,
    ])
  }

  certificate_policy {
    issuer_parameters {
      name = "Unknown"
    }

    key_properties {
      key_type   = "EC"
      curve      = "P-384"
      exportable = true
      reuse_key  = true
    }

    lifetime_action {
      action {
        action_type = "EmailContacts"
      }

      trigger {
        days_before_expiry = acme_certificate.apex[each.key].min_days_remaining
      }
    }

    secret_properties {
      content_type = "application/x-pem-file"
    }
  }
}
