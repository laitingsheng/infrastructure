provider "namecheap" {
  user_name   = var.github.username
  api_user    = var.github.username
  use_sandbox = false
}

# import {
#   id = "${var.domain}.io"
#   to = namecheap_domain_records.io
# }

# resource "namecheap_domain_records" "io" {
#   domain      = "${var.domain}.io"
#   mode        = "OVERWRITE"
#   nameservers = [for ns in azurerm_dns_zone.io.name_servers : trimsuffix(ns, ".")]
# }

# import {
#   id = "${var.domain}.ai"
#   to = namecheap_domain_records.ai
# }

# resource "namecheap_domain_records" "ai" {
#   domain      = "${var.domain}.ai"
#   mode        = "OVERWRITE"
#   nameservers = [for ns in azurerm_dns_zone.ai.name_servers : trimsuffix(ns, ".")]
# }

# import {
#   id = "${var.domain}.to"
#   to = namecheap_domain_records.to
# }

# resource "namecheap_domain_records" "to" {
#   domain     = "${var.domain}.to"
#   mode       = "OVERWRITE"
#   email_type = "NONE"
# }

# NameCheap API is not suitable for CI/CD, so all resources are commented out

removed {
  from = namecheap_domain_records.io

  lifecycle {
    destroy = false
  }
}

removed {
  from = namecheap_domain_records.ai

  lifecycle {
    destroy = false
  }
}

removed {
  from = namecheap_domain_records.to

  lifecycle {
    destroy = false
  }
}
