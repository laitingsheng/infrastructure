# provider "namecheap" {
#   user_name   = var.github.username
#   api_user    = var.github.username
#   use_sandbox = false
# }

# import {
#   id = "${var.domain}.io"
#   to = namecheap_domain_records.io
# }

# // TODO: primary domain, moved to Azure DNS after Namecheap Premium DNS expiration
# resource "namecheap_domain_records" "io" {
#   domain     = "${var.domain}.io"
#   mode       = "OVERWRITE"
#   email_type = "MX"

#   record {
#     hostname = "@"
#     type     = "TXT"
#     address  = "apple-domain=2NM29GAOQxCwLa1y"
#     ttl      = 60
#   }

#   record {
#     hostname = "@"
#     type     = "TXT"
#     address  = "MS=ms32071162"
#     ttl      = 60
#   }

#   record {
#     hostname = "_github-pages-challenge-${var.github.username}"
#     type     = "TXT"
#     address  = "6a163e92c888faaf9a3da476268978"
#     ttl      = 60
#   }

#   record {
#     hostname = "sig1._domainkey"
#     type     = "CNAME"
#     address  = "sig1.dkim.${var.domain}.io.at.icloudmailadmin.com."
#     ttl      = 60
#   }

#   dynamic "record" {
#     for_each = var.mailservers

#     content {
#       hostname = "@"
#       type     = "MX"
#       mx_pref  = 10
#       address  = "${record.value}."
#       ttl      = 60
#     }
#   }

#   record {
#     hostname = "@"
#     type     = "TXT"
#     address  = "v=spf1 mx ${join(" ", [for spf in var.spfs : "include:${spf}"])} -all"
#     ttl      = 60
#   }
# }

# import {
#   id = "${var.domain}.ai"
#   to = namecheap_domain_records.ai
# }

# resource "namecheap_domain_records" "ai" {
#   domain = "${var.domain}.ai"
#   mode   = "OVERWRITE"

#   nameservers = [for ns in azurerm_dns_zone.apex["ai"].name_servers : trimsuffix(ns, ".")]
# }

# NameCheap API is not suitable for CI/CD, so all resources are commented out

removed {
  from = namecheap_domain_records.ai

  lifecycle {
    destroy = false
  }
}

removed {
  from = namecheap_domain_records.io

  lifecycle {
    destroy = false
  }
}
