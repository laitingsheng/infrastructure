resource "tls_private_key" "acme" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"

  lifecycle {
    prevent_destroy = true
  }
}

resource "acme_registration" "main" {
  account_key_pem = tls_private_key.acme.private_key_pem
  email_address   = "acme@${var.domain}.io"

  lifecycle {
    prevent_destroy = true
  }
}

resource "tls_private_key" "csr" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P384"

  lifecycle {
    prevent_destroy = true
  }
}

resource "tls_cert_request" "io" {
  private_key_pem = tls_private_key.csr.private_key_pem

  dns_names = [
    "${var.domain}.io",
    "*.${var.domain}.io",
  ]

  subject {
    common_name = "${var.domain}.io"
  }
}

resource "acme_certificate" "io" {
  account_key_pem               = acme_registration.main.account_key_pem
  certificate_request_pem       = tls_cert_request.io.cert_request_pem
  min_days_remaining            = 40
  profile                       = "tlsserver"
  revoke_certificate_on_destroy = true
  revoke_certificate_reason     = "superseded"

  dns_challenge {
    provider = "azuredns"

    config = {
      AZURE_AUTH_METHOD    = "cli"
      AZURE_RESOURCE_GROUP = azurerm_dns_zone.io.resource_group_name
      AZURE_ZONE_NAME      = azurerm_dns_zone.io.name
    }
  }
}

resource "tls_cert_request" "ai" {
  private_key_pem = tls_private_key.csr.private_key_pem

  dns_names = [
    "${var.domain}.ai",
    "*.${var.domain}.ai",
  ]

  subject {
    common_name = "${var.domain}.ai"
  }
}

resource "acme_certificate" "ai" {
  account_key_pem               = acme_registration.main.account_key_pem
  certificate_request_pem       = tls_cert_request.ai.cert_request_pem
  min_days_remaining            = 40
  profile                       = "tlsserver"
  revoke_certificate_on_destroy = true
  revoke_certificate_reason     = "superseded"

  dns_challenge {
    provider = "azuredns"

    config = {
      AZURE_AUTH_METHOD    = "cli"
      AZURE_RESOURCE_GROUP = azurerm_dns_zone.ai.resource_group_name
      AZURE_ZONE_NAME      = azurerm_dns_zone.ai.name
    }
  }
}
