# import {
#   id = "${var.domain}.io"
#   to = namecheap_domain_records.io
# }

# resource "namecheap_domain_records" "io" {
#   domain      = "${var.domain}.io"
#   mode        = "OVERWRITE"
#   nameservers = cloudflare_zone.io.name_servers
# }

# import {
#   id = "${var.domain}.dev"
#   to = namecheap_domain_records.dev
# }

# resource "namecheap_domain_records" "dev" {
#   domain      = "${var.domain}.dev"
#   mode        = "OVERWRITE"
#   nameservers = cloudflare_zone.dev.name_servers
# }

# import {
#   id = "${var.domain}.ai"
#   to = namecheap_domain_records.ai
# }

# resource "namecheap_domain_records" "ai" {
#   domain      = "${var.domain}.ai"
#   mode        = "OVERWRITE"
#   nameservers = cloudflare_zone.ai.name_servers
# }

# import {
#   id = "${var.domain}.to"
#   to = namecheap_domain_records.to
# }

# resource "namecheap_domain_records" "to" {
#   domain      = cloudflare_zone.to.name
#   mode        = "OVERWRITE"
#   nameservers = cloudflare_zone.to.name_servers
# }

# NameCheap API is not suitable for CI/CD, so all resources are commented out

removed {
  from = namecheap_domain_records.io

  lifecycle {
    destroy = false
  }
}

removed {
  from = namecheap_domain_records.dev

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
