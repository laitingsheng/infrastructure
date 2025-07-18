locals {
  mailservers = [
    "mx01.mail.icloud.com",
    "mx02.mail.icloud.com",
  ]

  spfs = [
    "hotmail.com",
    "icloud.com",
    "outlook.com",
  ]

  dmarc-rua = {
    io  = "af391bb9fc5045f6b7e64b11b9c57e31"
    dev = "9058e6ab077947a48b1440451beda4df"
    ai  = "30047f56b47340de93be463ef42debaf"
    to  = "abead500a92243b69852c8843d8a206a"
  }
}

resource "cloudflare_zone" "io" {
  name = "${var.domain}.io"
  type = "full"

  account = {
    id = cloudflare_account.main.id
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_zone_dns_settings" "io" {
  zone_id             = cloudflare_zone.io.id
  flatten_all_cnames  = false
  foundation_dns      = false
  internal_dns        = {}
  multi_provider      = false
  ns_ttl              = 86400
  secondary_overrides = false
  zone_mode           = "standard"

  nameservers = {
    type = "cloudflare.standard"
  }

  lifecycle {
    ignore_changes = [soa]
  }
}

resource "cloudflare_zone_dnssec" "io" {
  zone_id = cloudflare_zone.io.id
  status  = "active"
}

resource "cloudflare_dns_record" "io-mx" {
  for_each = {
    for index, mailserver in local.mailservers : index => mailserver
  }

  name     = cloudflare_zone.io.name
  ttl      = 60
  type     = "MX"
  zone_id  = cloudflare_zone.io.id
  content  = each.value
  priority = 5
}

resource "cloudflare_dns_record" "io-spf" {
  name    = cloudflare_zone.io.name
  ttl     = 60
  type    = "TXT"
  zone_id = cloudflare_zone.io.id
  content = "v=spf1 ${join(" ", [for spf in local.spfs : "include:${spf}"])} -all"
}

resource "cloudflare_dns_record" "io-dmarc" {
  name    = "_dmarc.${cloudflare_zone.io.name}"
  ttl     = 60
  type    = "TXT"
  zone_id = cloudflare_zone.io.id
  content = "v=DMARC1; p=reject; aspf=s; adkim=r; rua=mailto:${local.dmarc-rua.io}@dmarc-reports.cloudflare.net;"
}

resource "cloudflare_dns_record" "io-icloud" {
  name    = cloudflare_zone.io.name
  ttl     = 60
  type    = "TXT"
  zone_id = cloudflare_zone.io.id
  content = "apple-domain=2NM29GAOQxCwLa1y"
}

resource "cloudflare_dns_record" "io-icloud-dkim" {
  name    = "sig1._domainkey.${cloudflare_zone.io.name}"
  ttl     = 60
  type    = "CNAME"
  zone_id = cloudflare_zone.io.id
  content = "sig1.dkim.${cloudflare_zone.io.name}.at.icloudmailadmin.com"
  proxied = false

  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_zone" "dev" {
  name = "${var.domain}.dev"
  type = "full"

  account = {
    id = cloudflare_account.main.id
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_zone_dns_settings" "dev" {
  zone_id             = cloudflare_zone.dev.id
  flatten_all_cnames  = false
  foundation_dns      = false
  internal_dns        = {}
  multi_provider      = false
  ns_ttl              = 86400
  secondary_overrides = false
  zone_mode           = "standard"

  nameservers = {
    type = "cloudflare.standard"
  }

  lifecycle {
    ignore_changes = [soa]
  }
}

resource "cloudflare_zone_dnssec" "dev" {
  zone_id = cloudflare_zone.dev.id
  status  = "active"
}

resource "cloudflare_dns_record" "dev-mx" {
  for_each = {
    for index, mailserver in local.mailservers : index => mailserver
  }

  name     = cloudflare_zone.dev.name
  ttl      = 60
  type     = "MX"
  zone_id  = cloudflare_zone.dev.id
  content  = each.value
  priority = 5
}

resource "cloudflare_dns_record" "dev-spf" {
  name    = cloudflare_zone.dev.name
  ttl     = 60
  type    = "TXT"
  zone_id = cloudflare_zone.dev.id
  content = "v=spf1 ${join(" ", [for spf in local.spfs : "include:${spf}"])} -all"
}

resource "cloudflare_dns_record" "dev-dmarc" {
  name    = "_dmarc.${cloudflare_zone.dev.name}"
  ttl     = 60
  type    = "TXT"
  zone_id = cloudflare_zone.dev.id
  content = "v=DMARC1; p=reject; aspf=s; adkim=r; rua=mailto:${local.dmarc-rua.dev}@dmarc-reports.cloudflare.net;"
}

resource "cloudflare_dns_record" "dev-icloud" {
  name    = cloudflare_zone.dev.name
  ttl     = 60
  type    = "TXT"
  zone_id = cloudflare_zone.dev.id
  content = "apple-domain=vQLg5DnkhVnwzEth"
}

resource "cloudflare_dns_record" "dev-icloud-dkim" {
  name    = "sig1._domainkey.${cloudflare_zone.dev.name}"
  ttl     = 60
  type    = "CNAME"
  zone_id = cloudflare_zone.dev.id
  content = "sig1.dkim.${cloudflare_zone.dev.name}.at.icloudmailadmin.com"
  proxied = false

  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_zone" "ai" {
  name = "${var.domain}.ai"
  type = "full"

  account = {
    id = cloudflare_account.main.id
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_zone_dns_settings" "ai" {
  zone_id             = cloudflare_zone.ai.id
  flatten_all_cnames  = false
  foundation_dns      = false
  internal_dns        = {}
  multi_provider      = false
  ns_ttl              = 86400
  secondary_overrides = false
  zone_mode           = "standard"

  nameservers = {
    type = "cloudflare.standard"
  }

  lifecycle {
    ignore_changes = [soa]
  }
}

resource "cloudflare_zone_dnssec" "ai" {
  zone_id = cloudflare_zone.ai.id
  status  = "active"
}

resource "cloudflare_dns_record" "ai-mx" {
  for_each = {
    for index, mailserver in local.mailservers : index => mailserver
  }

  name     = cloudflare_zone.ai.name
  ttl      = 60
  type     = "MX"
  zone_id  = cloudflare_zone.ai.id
  content  = each.value
  priority = 5
}

resource "cloudflare_dns_record" "ai-spf" {
  name    = cloudflare_zone.ai.name
  ttl     = 60
  type    = "TXT"
  zone_id = cloudflare_zone.ai.id
  content = "v=spf1 ${join(" ", [for spf in local.spfs : "include:${spf}"])} -all"
}

resource "cloudflare_dns_record" "ai-dmarc" {
  name    = "_dmarc.${cloudflare_zone.ai.name}"
  ttl     = 60
  type    = "TXT"
  zone_id = cloudflare_zone.ai.id
  content = "v=DMARC1; p=reject; aspf=s; adkim=r; rua=mailto:${local.dmarc-rua.ai}@dmarc-reports.cloudflare.net;"
}

resource "cloudflare_dns_record" "ai-icloud" {
  name    = cloudflare_zone.ai.name
  ttl     = 60
  type    = "TXT"
  zone_id = cloudflare_zone.ai.id
  content = "apple-domain=aHPHnTrksmYjFMlY"
}

resource "cloudflare_dns_record" "ai-icloud-dkim" {
  name    = "sig1._domainkey.${cloudflare_zone.ai.name}"
  ttl     = 60
  type    = "CNAME"
  zone_id = cloudflare_zone.ai.id
  content = "sig1.dkim.${cloudflare_zone.ai.name}.at.icloudmailadmin.com"
  proxied = false

  settings = {
    flatten_cname = false
  }
}

resource "cloudflare_zone" "to" {
  name = "${var.domain}.to"
  type = "full"

  account = {
    id = cloudflare_account.main.id
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_zone_dns_settings" "to" {
  zone_id             = cloudflare_zone.to.id
  flatten_all_cnames  = false
  foundation_dns      = false
  internal_dns        = {}
  multi_provider      = false
  ns_ttl              = 86400
  secondary_overrides = false
  zone_mode           = "standard"

  nameservers = {
    type = "cloudflare.standard"
  }

  lifecycle {
    ignore_changes = [soa]
  }
}

resource "cloudflare_dns_record" "to-spf" {
  name    = cloudflare_zone.to.name
  ttl     = 60
  type    = "TXT"
  zone_id = cloudflare_zone.to.id
  comment = "SPF"
  content = "v=spf1 -all"
}

resource "cloudflare_dns_record" "to-dmarc" {
  name    = "_dmarc.${cloudflare_zone.to.name}"
  ttl     = 60
  type    = "TXT"
  zone_id = cloudflare_zone.to.id
  comment = "DMARC"
  content = "v=DMARC1; p=reject; aspf=s; adkim=s; rua=mailto:${local.dmarc-rua.to}@dmarc-reports.cloudflare.net;"
}
