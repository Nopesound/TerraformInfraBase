locals {
  environment = terraform.workspace
  resource_group_name = {
    dev  = "rg-dev-infra"
    test = "rg-test-infra"
    prod = "rg-prod-infra"
  }
  sql_argo = {
    dev = {
      sql_server_name    = "sql-dev-argo"
      sql_server_version = "12.0"
      sql_admin_user     = "sqladmin"
    },
    test = {
      sql_server_name    = "sql-test-argo"
      sql_server_version = "12.0"
      sql_admin_user     = "sqladmin"
    },
    prod = {
      sql_server_name    = "sql-prod-argo"
      sql_server_version = "12.0"
      sql_admin_user     = "sqladmin"
    }
  }
  db_argo = {
    dev = {
      db_name               = "db-dev-argo"
      db_collation          = "SQL_Latin1_General_CP1_CI_AS"
      db_license_type       = "LicenseIncluded"
      db_max_size_gb        = 1
      db_sku_name           = "Basic"
      db_geo_backup_enabled = false
    },
    test = {
      db_name               = "db-test-argo"
      db_collation          = "SQL_Latin1_General_CP1_CI_AS"
      db_license_type       = "LicenseIncluded"
      db_max_size_gb        = 2
      db_sku_name           = "Basic"
      db_geo_backup_enabled = false
    },
    prod = {
      db_name               = "db-prod-argo"
      db_collation          = "SQL_Latin1_General_CP1_CI_AS"
      db_license_type       = "LicenseIncluded"
      db_max_size_gb        = 4
      db_sku_name           = "S0"
      db_geo_backup_enabled = true
    }
  }
}

resource "azurerm_mssql_server" "sql_argo" {
  name                         = local.sql_argo[local.environment].sql_server_name
  resource_group_name          = var.resource_group_name
  location                     = var.azure_region
  version                      = local.sql_argo[local.environment].sql_server_version
  administrator_login          = local.sql_argo[local.environment].sql_admin_user
  administrator_login_password = var.sql_admin_psw

}
resource "azurerm_mssql_database" "db_argo" {
  name               = local.db_argo[local.environment].db_name
  server_id          = azurerm_mssql_server.sql_argo.id
  collation          = local.db_argo[local.environment].db_collation
  license_type       = local.db_argo[local.environment].db_license_type
  max_size_gb        = local.db_argo[local.environment].db_max_size_gb
  sku_name           = local.db_argo[local.environment].db_sku_name
  geo_backup_enabled = local.db_argo[local.environment].db_geo_backup_enabled
  depends_on         = [azurerm_mssql_server.sql_argo]
}
# resource "mssql_login" "sql_login_argo" {
#   server {
#     host = "${azurerm_mssql_database.db_argo.name}.database.windows.net"
#     login {
#       username = local.sql_argo[local.environment].sql_admin_user
#       password = var.sql_admin_psw
#     }
#   }
#   login_name = var.sql_dbuser_argo_username
#   password   = var.sql_dbuser_argo_password
#   depends_on = [azurerm_mssql_database.sqldb_argo]
# }

# resource "mssql_user" "sql_user_argo" {
#   server {
#     host = "${azurerm_mssql_database.db_argo.name}.database.windows.net"
#     login {
#       username = local.sql_argo[local.environment].sql_admin_user
#       password = var.sql_admin_psw
#     }
#   }
#   username   = var.sql_dbuser_argo_username
#   password   = var.sql_dbuser_argo_password
#   database   = var.sql_db_argo_name
#   roles      = var.sql_dbuser_argo_roles
#   depends_on = [azurerm_mssql_database.sqldb_argo, mssql_login.sql_login_argo]
# }
# resource "azurerm_key_vault_secret" "db_argo_connectionstring" {
#   name         = "${azurerm_mssql_database.db_argo.name}-connectionstring"
#   value        = "Server=tcp:${azurerm_mssql_server.sql_argo.name}.database.windows.net,1433;Initial Catalog=${azurerm_mssql_database.db_argo.name};Persist Security Info=False;User ID=${var.sql_dbuser_argo_username};Password=${var.sql_dbuser_argo_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
#   key_vault_id = var.kv_argo_id
#   tags         = {}
#   depends_on   = [azurerm_mssql_database.sqldb_authentication]
# }