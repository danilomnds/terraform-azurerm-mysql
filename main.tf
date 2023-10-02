resource "random_password" "password" {
  length           = 16
  special          = true
  min_special      = 2
  min_numeric      = 2
  min_upper        = 2
  min_lower        = 2
  override_special = "#"
}

resource "azurerm_mysql_flexible_server" "mysql_flexible_server" {
  depends_on             = [random_password.password]
  name                   = var.name
  resource_group_name    = var.resource_group_name
  location               = var.location
  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password == null ? random_password.password.result : var.administrator_password
  backup_retention_days  = var.backup_retention_days
  create_mode            = var.create_mode
  dynamic "customer_managed_key" {
    for_each = var.customer_managed_key != null ? [var.customer_managed_key] : []
    content {
      key_vault_key_id                     = lookup(customer_managed_key.value, "key_vault_key_id", null)
      primary_user_assigned_identity_id    = lookup(customer_managed_key.value, "primary_user_assigned_identity_id", null)
      geo_backup_key_vault_key_id          = lookup(customer_managed_key.value, "geo_backup_key_vault_key_id", null)
      geo_backup_user_assigned_identity_id = lookup(customer_managed_key.value, "geo_backup_user_assigned_identity_id", null)
    }
  }
  delegated_subnet_id          = var.delegated_subnet_id
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled
  dynamic "high_availability" {
    for_each = var.high_availability != null ? [var.high_availability] : []
    content {
      mode                      = high_availability.value.mode
      standby_availability_zone = high_availability.value.standby_availability_zone
    }
  }
  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []
    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }
  dynamic "maintenance_window" {
    for_each = var.maintenance_window != null ? [var.maintenance_window] : []
    content {
      day_of_week  = lookup(maintenance_window.value, "day_of_week", 0)
      start_hour   = lookup(maintenance_window.value, "start_hour", 0)
      start_minute = lookup(maintenance_window.value, "start_minute", 0)
    }
  }
  point_in_time_restore_time_in_utc = var.point_in_time_restore_time_in_utc
  private_dns_zone_id               = var.private_dns_zone_id
  replication_role                  = var.replication_role
  sku_name                          = var.sku_name
  source_server_id                  = var.source_server_id
  dynamic "storage" {
    for_each = var.storage != null ? [var.storage] : []
    content {
      auto_grow_enabled = lookup(storage.value, "auto_grow_enabled", true)
      iops              = lookup(storage.value, "iops", null)
      size_gb           = lookup(storage.value, "size_gb", null)
    }
  }
  version = var.version
  zone    = var.zone
  tags    = local.tags
  lifecycle {
    ignore_changes = [
      tags["create_date"], zone, high_availability.0.standby_availability_zone
    ]
  }
}

resource "azurerm_mysql_flexible_database" "mysql_flexible_db" {
  depends_on = [azurerm_mysql_flexible_server.mysql_flexible_server]
  for_each = {
    for k, v in toset(var.databases) : k => v
    if var.databases != null
  }
  name                = each.value.name
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.mysql_flexible_server.name
  charset             = each.value.charset
  collation           = each.value.collation
}

resource "azurerm_mysql_flexible_server_configuration" "mysql_configuration" {
  depends_on = [azurerm_mysql_flexible_server.mysql_flexible_server]
  for_each = {
    for k, v in toset(var.mysql_configuration) : k => v
    if var.mysql_configuration != null
  }
  name                = each.key
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.mysql_flexible_server.name
  value               = each.value
}

resource "azurerm_role_assignment" "mysql_reader" {
  depends_on = [azurerm_mysql_flexible_server.mysql_flexible_server]
  for_each = {
    for group in var.azure_ad_groups : group => group
    if var.reader_mysql && var.azure_ad_groups != []
  }
  scope                = azurerm_mysql_flexible_server.mysql_flexible_server.id
  role_definition_name = "Reader"
  principal_id         = each.value
}