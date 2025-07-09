resource "tls_private_key" "acme" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

resource "acme_registration" "main" {
  account_key_pem = tls_private_key.acme.private_key_pem
  email_address   = "acme@${var.apex.name}.io"

  external_account_binding {
    key_id      = data.azurerm_key_vault_secret.acme-eab-key-id.value
    hmac_base64 = data.azurerm_key_vault_secret.acme-eab-hmac.value
  }
}

resource "tls_private_key" "csr" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"
}

resource "tls_cert_request" "apex" {
  for_each = var.apex.suffices

  private_key_pem = tls_private_key.csr.private_key_pem
  dns_names       = ["${var.apex.name}.${each.key}", "*.${var.apex.name}.${each.key}"]

  subject {
    common_name   = "${var.apex.name}.${each.key}"
    email_address = "certificate@${var.apex.name}.${each.key}"
  }
}

resource "acme_certificate" "apex" {
  for_each = var.apex.suffices

  account_key_pem               = tls_private_key.acme.private_key_pem
  certificate_request_pem       = tls_cert_request.apex[each.key].cert_request_pem
  min_days_remaining            = 30
  revoke_certificate_on_destroy = true
  revoke_certificate_reason     = "unspecified"

  dns_challenge {
    provider = "azuredns"

    config = {
      AZURE_AUTH_METHOD    = "cli"
      AZURE_RESOURCE_GROUP = azurerm_resource_group.connectivity.name
      AZURE_ZONE_NAME      = "${var.apex.name}.${each.key}"
    }
  }
}
