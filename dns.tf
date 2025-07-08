resource "azurerm_dns_zone" "apex" {
  for_each = var.apex.suffices

  name                = "${var.apex.name}.${each.key}"
  resource_group_name = azurerm_resource_group.connectivity.name

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_dns_txt_record" "apex" {
  for_each = var.apex.suffices

  name                = "@"
  resource_group_name = azurerm_dns_zone.apex[each.key].resource_group_name
  zone_name           = azurerm_dns_zone.apex[each.key].name
  ttl                 = 3600

  record {
    value = "apple-domain=${each.value.apple}"
  }

  record {
    value = "_github-pages-challenge-${var.github-username}=${each.value.github}"
  }

  record {
    value = "MS=${each.value.microsoft}"
  }

  record {
    value = "v=spf1 ${join(" ", [for spf in var.apex.spfs : "include:${spf}"])} ~all"
  }
}

resource "azurerm_dns_mx_record" "apex" {
  for_each = var.apex.suffices

  name                = "@"
  resource_group_name = azurerm_dns_zone.apex[each.key].resource_group_name
  zone_name           = azurerm_dns_zone.apex[each.key].name
  ttl                 = 3600

  dynamic "record" {
    for_each = var.apex.mailservers

    content {
      preference = 10
      exchange   = "${record.value}."
    }
  }
}

resource "azurerm_dns_cname_record" "apex-icloud-signature" {
  for_each = var.apex.suffices

  name                = "sig1._domainkey"
  resource_group_name = azurerm_dns_zone.apex[each.key].resource_group_name
  zone_name           = azurerm_dns_zone.apex[each.key].name
  ttl                 = 3600
  record              = "sig1.dkim.${var.apex.name}.${each.key}.at.icloudmailadmin.com."
}
