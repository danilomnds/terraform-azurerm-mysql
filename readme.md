# Module - Azure MySQL Flexible Server
[![COE](https://img.shields.io/badge/Created%20By-CCoE-blue)]()
[![HCL](https://img.shields.io/badge/language-HCL-blueviolet)](https://www.terraform.io/)
[![Azure](https://img.shields.io/badge/provider-Azure-blue)](https://registry.terraform.io/providers/hashicorp/azurerm/latest)

Module developed to standardize the creation of MySQL Flexible Server.

## Compatibility Matrix

| Module Version | Terraform Version | AzureRM Version |
|----------------|-------------------| --------------- |
| v1.0.0         | v1.5.7            | 3.74.0          |

## Specifying a version

To avoid that your code get updates automatically, is mandatory to set the version using the `source` option. 
By defining the `?ref=***` in the the URL, you can define the version of the module.

Note: The `?ref=***` refers a tag on the git module repo.

## Use case
```hcl
module "mysql-flex-<system>-<env>" {
  source              = "git::https://github.com/danilomnds/terraform-azurerm-mysql?ref=v1.0.0"
  name                = "mysql-flex-<system>-<env>"
  location            = <location>
  resource_group_name = <resource group name>
  version             = <version>
  sku_name            = <virtual machine shape>
  delegated_subnet_id = "subnet id"
  private_dns_zone_id = "private dns zone id"
  zone                = <1|2|3>
  backup_retention_days = <default 7>
  high_availability = { 
    mode = <SameZone|ZoneRedundant>
    standby_availability_zone = <ex: 2>
  }  
  storage = {
    size_gb           = <ex: 200>
    iops              = <ex: 900>
    auto_grow_enabled = <ex: true>
  }
  tags = {
    key1 = value1
    key2 = value2
  }
  databases = [
    {
     name = "db01"
     charset = "utf8mb3"
     collation = "utf8mb3_general_ci"
    },
    {
     name = "db02"
     charset = "utf8mb3"
     collation = "utf8mb3_general_ci"
    },
  ]
  mysql_configuration = [
    { 
      name = sql_generate_invisible_primary_key
      value = "OFF" 
    },
    { 
      name = parameter2
      value = value2
    },
  ]
  azure_ad_groups = ["group 1 that will have reader access on mysql", "group 2"]
}
```

## Input variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | eventhub namespace name | `string` | n/a | `Yes` |
| resource_group_name | resource group where the ACR will be placed | `string` | n/a | `Yes` |
| location | azure region | `string` | n/a | `Yes` |
| administrator_login | the administrator login for the mysql flexible server | `string` | `mysqladmin` | No |
| administrator_password | the password associated with the administrator_login for the mysql flexible server | `string` | n/a | No |
| backup_retention_days | the backup retention days for the mysql flexible server | `number` | `7` | No |
| create_mode | the creation mode which can be used to restore or replicate existing servers | `string` | n/a | No |
| customer_managed_key | a block as defined below | `object({})` | n/a | No |
| delegated_subnet_id | the id of the virtual network subnet to create the mysql flexible server | `string` | n/a | No |
| geo_redundant_backup_enabled | should geo redundant backup enabled?  | `bool` | `false` | No |
| high_availability | a block as defined below | `object({})` | n/a | No |
| identity | a block as defined below | `object({})` | n/a | No |
| maintenance_window | a block as defined below | `object({})` | n/a | No |
| point_in_time_restore_time_in_utc | the point in time to restore from creation_source_server_id when create_mode is pointintimerestore | `string` | n/a | No |
| private_dns_zone_id | the id of the private dns zone to create the mysql flexible server | `string` | n/a | No |
| replication_role | the replication role. possible value is none | `string` | n/a | No |
| sku_name | the sku name for the mysql flexible server | `string` | n/a | `Yes` |
| source_server_id | the resource id of the source mysql flexible server to be restored | `string` | n/a | No |
| storage | a block as defined below | `object({})` | n/a | No |
| version | the version of the mysql flexible server to use | `string` | n/a | `Yes` |
| zone | specifies the availability zone in which this mysql flexible server should be located | `string` | n/a | No |
| tags | tags for the resource | `map(string)` | `{}` | No |
| azure_ad_groups | list of azure AD groups that will be granted the Application Insights Component Contributor role  | `list` | `[]` | No |
| databases | a list object variable defined below | `list(object({}))` | n/a | No |
| reader_mysql | should reader access granted? | `bool` | `True` | No |
| mysql_configuration | a list object variable defined below | `list(object({}))` | n/a | No |


# Object variables for blocks

| Variable Name (Block) | Parameter | Description | Type | Default | Required |
|-----------------------|-----------|-------------|------|---------|:--------:|
| customer_managed_key | key_vault_key_id | the id of the key vault key | `string` | `null` | No |
| customer_managed_key | primary_user_assigned_identity_id | specifies the primary user managed identity id for a customer managed key | `string` | `null` | No |
| customer_managed_key | geo_backup_key_vault_key_id | the id of the geo backup key vault key | `string` | `null` | No |
| customer_managed_key | geo_backup_user_assigned_identity_id | the geo backup user managed identity id for a customer managed key | `string` | `null` | No |
| identity | type | specifies the type of managed service identity that should be configured on this event hub namespace | `string` | `null` | No |
| identity | identity_ids | specifies a list of user assigned managed identity ids to be assigned to this eventhub namespace | `list(string)` | `null` | No |
| high_availability | mode | the high availability mode for the mysql flexible server. possibles values are samezone and zoneredundant | `string` | `null` | `Yes` |
| high_availability | standby_availability_zone | specifies the availability zone in which the standby flexible server should be located | `list(string)` | `null` | No |
| high_availability | mode | the high availability mode for the mysql flexible server. possibles values are samezone and zoneredundant | `string` | `null` | `Yes` |
| high_availability | standby_availability_zone | specifies the availability zone in which the standby flexible server should be located | `list(string)` | `null` | No |
| maintenance_window | day_of_week | the day of week for maintenance window | `number` | `0` | No |
| maintenance_window | start_hour | the start hour for maintenance window | `number` | `0` | No |
| maintenance_window | start_minute | the start minute for maintenance window | `number` | `0` | No |
| storage | auto_grow_enabled | the day of week for maintenance window | `bool` | `True` | No |
| storage | iops | the storage iops for the mysql flexible server | `number` | `null` | No |
| storage | size_gb | the max storage allowed for the mysql flexible server | `number` | `null` | No |
| databases | name | database name | `string` | n/a | `Yes` |
| databases | charset | database charset | `string` | n/a | `Yes` |
| databases | collation | database collation | `string` | n/a | `Yes` |
| mysql_configuration | name | specifies the name of the mysql flexible server configuration, which needs to be a valid mysql configuration name | `string` | n/a | `Yes` |
| mysql_configuration | value | specifies the value of the mysql flexible server configuration. see the mysql documentation for valid values | `string` | n/a | `Yes` |

  ## Output variables

| Name | Description |
|------|-------------|
| name | flexible server name|
| id | flexible server id |
| dbs | flexible database id |
| configs | flexible configuration id| 

## Documentation
MySQL Flexible Server: <br>
[https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server)
MySQL Flexible Database: <br>
[https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_database](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_database)
MySQL Flexible Configuration: <br>
[https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server_configuration](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mysql_flexible_server_configuration)