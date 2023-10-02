variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "administrator_login" {
  description = "mysql administrator login"
  type        = string
  default     = "mysqladmin"
}

variable "administrator_password" {
  description = "mysql administrator password. Strong Password : https://docs.microsoft.com/en-us/sql/relational-databases/security/strong-passwords?view=sql-server-2017."
  type        = string
  default     = null
}

variable "backup_retention_days" {
  description = "Backup retention days for the mysql Flexible Server (Between 7 and 35 days)."
  type        = number
  default     = 7
}

variable "create_mode" {
  type    = string
  default = null
}

variable "customer_managed_key" {
  type = object({
    key_vault_key_id                     = optional(string)
    primary_user_assigned_identity_id    = optional(string)
    geo_backup_key_vault_key_id          = optional(string)
    geo_backup_user_assigned_identity_id = optional(string)
  })
  default = null
}

variable "delegated_subnet_id" {
  description = "Id of the subnet to create the mysql Flexible Server. (Should not have any resource deployed in)"
  type        = string
  default     = null
}

variable "geo_redundant_backup_enabled" {
  type    = bool
  default = false
}

variable "high_availability" {
  type = object({
    mode                      = string
    standby_availability_zone = number
  })
  default = null
}

variable "identity" {
  description = "Specifies the type of Managed Service Identity that should be configured on this resource"
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  default = null
}

variable "maintenance_window" {
  type = object({
    day_of_week  = optional(number)
    start_hour   = optional(number)
    start_minute = optional(number)
  })
  default = null
}

variable "point_in_time_restore_time_in_utc" {
  type    = string
  default = null
}

variable "private_dns_zone_id" {
  description = "ID of the private DNS zone to create the mysql Flexible Server"
  type        = string
  default     = null
}

variable "replication_role" {
  type    = string
  default = null
}

variable "sku_name" {
  description = "Size for mysql Flexible server sku : https://docs.microsoft.com/en-us/azure/mysql/flexible-server/concepts-compute-storage."
  type        = string
}

variable "source_server_id" {
  type    = string
  default = null
}

variable "storage" {
  description = "Map of the storage configuration"
  type = object({
    auto_grow_enabled = optional(bool)
    iops              = optional(number)
    size_gb           = optional(number)
  })
  default = null
}

variable "mysql_version" {
  description = "Version of mysql Flexible Server. Possible values are : https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server#version."
  type        = string
}

variable "zone" {
  description = "Specify availability-zone for mysql Flexible main Server."
  type        = number
  default     = null
}

variable "tags" {
  description = "A map of tags to set on every taggable resources. Empty by default."
  type        = map(string)
  default     = {}
}

variable "databases" {
  type = list(object({
    name      = string
    charset   = string
    collation = string
  }))
  default = null
}

variable "azure_ad_groups" {
  type    = list(string)
  default = []
}

variable "reader_mysql" {
  description = "Grants reader permissions on MySQL Flexible Server"
  type        = bool
  default     = true
}

variable "mysql_configuration" {
  type = list(object({
    name = string
    value = string 
  }))
  default = null
}