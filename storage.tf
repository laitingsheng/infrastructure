resource "azurerm_storage_account" "main" {
  name                              = "sabaseea"
  resource_group_name               = azurerm_resource_group.main.name
  location                          = azurerm_resource_group.main.location
  account_kind                      = "StorageV2"
  account_tier                      = "Standard"
  account_replication_type          = "GZRS"
  cross_tenant_replication_enabled  = false
  access_tier                       = "Hot"
  https_traffic_only_enabled        = true
  min_tls_version                   = "TLS1_2"
  allow_nested_items_to_be_public   = false
  shared_access_key_enabled         = false
  public_network_access_enabled     = true
  default_to_oauth_authentication   = true
  is_hns_enabled                    = false
  nfsv3_enabled                     = false
  large_file_share_enabled          = true
  local_user_enabled                = false
  queue_encryption_key_type         = "Account"
  table_encryption_key_type         = "Account"
  infrastructure_encryption_enabled = true
  allowed_copy_scope                = "AAD"
  sftp_enabled                      = false
  dns_endpoint_type                 = "Standard"

  blob_properties {
    versioning_enabled            = true
    change_feed_enabled           = true
    change_feed_retention_in_days = 7
    last_access_time_enabled      = true

    delete_retention_policy {
      days                     = 30
      permanent_delete_enabled = false
    }

    restore_policy {
      days = 28
    }

    container_delete_retention_policy {
      days = 30
    }
  }

  routing {
    publish_internet_endpoints  = false
    publish_microsoft_endpoints = false
    choice                      = "MicrosoftRouting"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = "private"

  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_r2_bucket" "public" {
  account_id    = cloudflare_account.main.id
  name          = "public"
  jurisdiction  = "default"
  location      = "APAC"
  storage_class = "Standard"
}

resource "cloudflare_r2_managed_domain" "public" {
  account_id   = cloudflare_r2_bucket.public.account_id
  bucket_name  = cloudflare_r2_bucket.public.name
  enabled      = false
  jurisdiction = cloudflare_r2_bucket.public.jurisdiction
}

resource "cloudflare_r2_custom_domain" "public" {
  for_each = {
    io  = cloudflare_zone.io
    dev = cloudflare_zone.dev
    ai  = cloudflare_zone.ai
  }

  account_id   = cloudflare_r2_bucket.public.account_id
  bucket_name  = cloudflare_r2_bucket.public.name
  domain       = "${cloudflare_r2_bucket.public.name}.${each.value.name}"
  enabled      = true
  zone_id      = each.value.id
  jurisdiction = cloudflare_r2_bucket.public.jurisdiction
  min_tls      = "1.2"
}
