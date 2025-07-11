resource "cloudflare_zone" "io" {
  name   = "${var.domain}.io"
  paused = false
  type   = "full"

  account = {
    id = cloudflare_account.main.id
  }
}

resource "cloudflare_zone_setting" "io" {
  for_each = {
    automatic_https_rewrites = "off"
    min_tls_version          = "1.2"
    tls_1_3                  = "off"
  }

  setting_id = each.key
  value      = each.value
  zone_id    = cloudflare_zone.io.id
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
}

resource "cloudflare_zone_dnssec" "io" {
  zone_id = cloudflare_zone.io.id
  status  = "active"
}

resource "cloudflare_dns_record" "io" {
  for_each = {
    for obj in concat(
      [
        for index, mailserver in var.mailservers : {
          type     = "MX"
          content  = mailserver
          priority = 10
          tag      = index
        }
      ],
      [
        {
          type    = "TXT"
          content = "apple-domain=2NM29GAOQxCwLa1y"
          tag     = "icloud"
        },
        {
          type    = "TXT"
          content = "MS=ms32071162"
          tag     = "microsoft-entra"
        },
        {
          type    = "TXT"
          content = "v=spf1 ${join(" ", [for spf in var.spfs : "include:${spf}"])} -all"
          tag     = "spf"
        },
        {
          subdomain = "_github-pages-challenge-${var.github.username}"
          type      = "TXT"
          content   = "6a163e92c888faaf9a3da476268978"
        },
        {
          subdomain = "sig1._domainkey"
          type      = "CNAME"
          content   = "sig1.dkim.${cloudflare_zone.io.name}.at.icloudmailadmin.com"
        },
      ],
      ) : join("/", compact([
        obj.type,
        try(obj.tag, null),
        try(obj.subdomain, "@"),
    ])) => obj
  }

  name     = join(".", compact([try(each.value.subdomain, null), cloudflare_zone.io.name]))
  ttl      = try(each.value.ttl, 3600)
  type     = each.value.type
  zone_id  = cloudflare_zone.io.id
  content  = each.value.content
  priority = try(each.value.priority, null)
  proxied  = false

  settings = {
    flatten_cname = false
    ipv4_only     = false
    ipv6_only     = false
  }
}

resource "cloudflare_zone" "ai" {
  name   = "${var.domain}.ai"
  paused = false
  type   = "full"

  account = {
    id = cloudflare_account.main.id
  }
}

resource "cloudflare_zone_setting" "ai" {
  for_each = {
    automatic_https_rewrites = "off"
    min_tls_version          = "1.2"
    tls_1_3                  = "off"
  }

  setting_id = each.key
  value      = each.value
  zone_id    = cloudflare_zone.ai.id
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
}

resource "cloudflare_zone_dnssec" "ai" {
  zone_id = cloudflare_zone.ai.id
  status  = "active"
}

resource "cloudflare_dns_record" "ai" {
  for_each = {
    for obj in concat(
      [
        for index, mailserver in var.mailservers : {
          type     = "MX"
          content  = mailserver
          priority = 10
          tag      = index
        }
      ],
      [
        {
          type    = "TXT"
          content = "apple-domain=aHPHnTrksmYjFMlY"
          tag     = "icloud"
        },
        {
          type    = "TXT"
          content = "MS=ms59054622"
          tag     = "microsoft-entra"
        },
        {
          type    = "TXT"
          content = "v=spf1 ${join(" ", [for spf in var.spfs : "include:${spf}"])} -all"
          tag     = "spf"
        },
        {
          subdomain = "_github-pages-challenge-${var.github.username}"
          type      = "TXT"
          content   = "4d33107c20ea1f9890015edbbd797d"
        },
        {
          subdomain = "sig1._domainkey"
          type      = "CNAME"
          content   = "sig1.dkim.${cloudflare_zone.ai.name}.at.icloudmailadmin.com"
        },
      ],
      ) : join("/", compact([
        obj.type,
        try(obj.tag, null),
        try(obj.subdomain, "@"),
    ])) => obj
  }

  name     = join(".", compact([try(each.value.subdomain, null), cloudflare_zone.ai.name]))
  ttl      = try(each.value.ttl, 3600)
  type     = each.value.type
  zone_id  = cloudflare_zone.ai.id
  content  = each.value.content
  priority = try(each.value.priority, null)
  proxied  = false

  settings = {
    flatten_cname = false
    ipv4_only     = false
    ipv6_only     = false
  }
}

resource "cloudflare_zone" "to" {
  name   = "${var.domain}.to"
  paused = false
  type   = "full"

  account = {
    id = cloudflare_account.main.id
  }
}

resource "cloudflare_zone_setting" "to" {
  for_each = {
    automatic_https_rewrites = "off"
    min_tls_version          = "1.2"
    tls_1_3                  = "off"
  }

  setting_id = each.key
  value      = each.value
  zone_id    = cloudflare_zone.to.id
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
}

resource "cloudflare_zone_dnssec" "to" {
  zone_id = cloudflare_zone.to.id
  status  = "disabled"
}
