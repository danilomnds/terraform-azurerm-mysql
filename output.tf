output "name" {
  value = azurerm_mysql_flexible_server.mysql_flexible_server.name
}

output "id" {
  value = azurerm_mysql_flexible_server.mysql_flexible_server.id
}

output "dbs" {
  description = "dbs"
  value       = [for dbs in azurerm_mysql_flexible_database.mysql_flexible_db : dbs.id]
}

output "configs" {
  description = "configs"
  value       = [for configs in azurerm_mysql_flexible_server_configuration.mysql_configuration : configs.id]
}