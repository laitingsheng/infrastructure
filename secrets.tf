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
    email = "expiry@${var.domain}.io"
  }
}

resource "azurerm_key_vault_certificate" "io" {
  name         = "${var.domain}-io-wildcard"
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

      subject = "CN=*.${var.domain}.io"

      subject_alternative_names {
        dns_names = [
          "*.${var.domain}.io",
          "${var.domain}.io",
        ]
      }

      validity_in_months = 12
    }
  }
}

resource "azurerm_key_vault_certificate" "io-acme" {
  name         = "${var.domain}-io-acme"
  key_vault_id = azurerm_key_vault.main.id

  certificate {
    contents = join("\n", [
      acme_certificate.io.certificate_pem,
      acme_certificate.io.issuer_pem,
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
      exportable = false
      reuse_key  = false
    }

    lifetime_action {
      action {
        action_type = "EmailContacts"
      }

      trigger {
        days_before_expiry = acme_certificate.io.min_days_remaining
      }
    }

    secret_properties {
      content_type = "application/x-pem-file"
    }
  }
}

resource "azurerm_key_vault_certificate" "ai-acme" {
  name         = "${var.domain}-ai-acme"
  key_vault_id = azurerm_key_vault.main.id

  certificate {
    contents = join("\n", [
      acme_certificate.ai.certificate_pem,
      acme_certificate.ai.issuer_pem,
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
      exportable = false
      reuse_key  = false
    }

    lifetime_action {
      action {
        action_type = "EmailContacts"
      }

      trigger {
        days_before_expiry = acme_certificate.ai.min_days_remaining
      }
    }

    secret_properties {
      content_type = "application/x-pem-file"
    }
  }
}
