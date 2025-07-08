locals {
  mailservers = [
    "mx01.mail.icloud.com",
    "mx02.mail.icloud.com",
  ]

  spfs = [
    "icloud.com",
  ]
}

resource "azurerm_dns_zone" "io" {
  name                = "${var.domain}.io"
  resource_group_name = azurerm_resource_group.main.name

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_dns_cname_record" "io" {
  for_each = {
    for obj in [
      {
        name   = "sig1._domainkey"
        record = "sig1.dkim.${azurerm_dns_zone.io.name}.at.icloudmailadmin.com."
      },
    ] : (obj.name) => obj
  }

  name                = each.value.name
  resource_group_name = azurerm_dns_zone.io.resource_group_name
  zone_name           = azurerm_dns_zone.io.name
  ttl                 = try(each.value.ttl, 3600)
  record              = each.value.record
}

resource "azurerm_dns_mx_record" "io" {
  name                = "@"
  resource_group_name = azurerm_dns_zone.io.resource_group_name
  zone_name           = azurerm_dns_zone.io.name
  ttl                 = 3600

  dynamic "record" {
    for_each = local.mailservers

    content {
      preference = 10
      exchange   = "${record.value}."
    }
  }
}

resource "azurerm_dns_txt_record" "io" {
  for_each = {
    for obj in [
      {
        name = "@"

        records = [
          "apple-domain=2NM29GAOQxCwLa1y",
          "MS=ms32071162",
          "v=spf1 ${join(" ", [for spf in local.spfs : "include:${spf}"])} -all",
        ]
      },
    ] : (obj.name) => obj
  }

  name                = each.value.name
  resource_group_name = azurerm_dns_zone.io.resource_group_name
  zone_name           = azurerm_dns_zone.io.name
  ttl                 = try(each.value.ttl, 3600)

  dynamic "record" {
    for_each = each.value.records

    content {
      value = record.value
    }
  }
}

resource "azurerm_dns_zone" "ai" {
  name                = "${var.domain}.ai"
  resource_group_name = azurerm_resource_group.main.name

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_dns_cname_record" "ai" {
  for_each = {
    for obj in [
      {
        name   = "sig1._domainkey"
        record = "sig1.dkim.${azurerm_dns_zone.ai.name}.at.icloudmailadmin.com."
      },
    ] : (obj.name) => obj
  }

  name                = each.value.name
  resource_group_name = azurerm_dns_zone.ai.resource_group_name
  zone_name           = azurerm_dns_zone.ai.name
  ttl                 = try(each.value.ttl, 3600)
  record              = each.value.record
}

resource "azurerm_dns_mx_record" "ai" {
  name                = "@"
  resource_group_name = azurerm_dns_zone.ai.resource_group_name
  zone_name           = azurerm_dns_zone.ai.name
  ttl                 = 3600

  dynamic "record" {
    for_each = local.mailservers

    content {
      preference = 10
      exchange   = "${record.value}."
    }
  }
}

resource "azurerm_dns_txt_record" "ai" {
  for_each = {
    for obj in [
      {
        name = "@"

        records = [
          "apple-domain=aHPHnTrksmYjFMlY",
          "MS=ms59054622",
          "v=spf1 ${join(" ", [for spf in local.spfs : "include:${spf}"])} -all",
        ]
      },
    ] : (obj.name) => obj
  }

  name                = each.value.name
  resource_group_name = azurerm_dns_zone.ai.resource_group_name
  zone_name           = azurerm_dns_zone.ai.name
  ttl                 = try(each.value.ttl, 3600)

  dynamic "record" {
    for_each = each.value.records

    content {
      value = record.value
    }
  }
}
