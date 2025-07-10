resource "azurerm_dns_zone" "apex" {
  for_each = toset(["ai"])

  name                = "${var.domain}.${each.key}"
  resource_group_name = azurerm_resource_group.connectivity.name

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_dns_txt_record" "apex" {
  for_each = {
    for key, value in {
      ai = {
        icloud          = "aHPHnTrksmYjFMlY"
        microsoft-entra = "ms59054622"
      }
      } : key => merge(
      azurerm_dns_zone.apex[key],
      {
        records = [
          "apple-domain=${value.icloud}",
          "MS=${value.microsoft-entra}",
          "v=spf1 mx ${join(" ", [for spf in var.spfs : "include:${spf}"])} -all",
        ]
      },
    )
  }

  name                = "@"
  resource_group_name = each.value.resource_group_name
  zone_name           = each.value.name
  ttl                 = 60

  dynamic "record" {
    for_each = each.value.records

    content {
      value = record.value
    }
  }
}

resource "azurerm_dns_mx_record" "apex" {
  for_each = azurerm_dns_zone.apex

  name                = "@"
  resource_group_name = each.value.resource_group_name
  zone_name           = each.value.name
  ttl                 = 60

  dynamic "record" {
    for_each = var.mailservers

    content {
      preference = 10
      exchange   = "${record.value}."
    }
  }
}

resource "azurerm_dns_txt_record" "apex-github-pages" {
  for_each = {
    for key, value in {
      ai = "4d33107c20ea1f9890015edbbd797d"
      } : key => merge(
      azurerm_dns_zone.apex[key],
      {
        record = value
      },
    )
  }

  name                = "_github-pages-challenge-${var.github.username}"
  resource_group_name = each.value.resource_group_name
  zone_name           = each.value.name
  ttl                 = 60

  record {
    value = each.value.record
  }
}

resource "azurerm_dns_cname_record" "apex-icloud-signature" {
  for_each = azurerm_dns_zone.apex

  name                = "sig1._domainkey"
  resource_group_name = each.value.resource_group_name
  zone_name           = each.value.name
  ttl                 = 60
  record              = "sig1.dkim.${each.value.name}.at.icloudmailadmin.com."
}
