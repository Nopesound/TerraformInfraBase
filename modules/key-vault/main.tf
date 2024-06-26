locals {
  resource_group_name = {
    dev  = "rg-dev-infra"
    test = "rg-test-infra"
    prod = "rg-prod-infra"
  }
  kv_argo = {
    dev = {
      name                        = "kv-argo-dev-we-001"
      enabled_for_disk_encryption = true
      soft_delete_retention_days  = 7
      purge_protection_enabled    = false
      keyvault_sku                = "standard"
    }
    test = {
      name                        = "kv-argo-test-we-001"
      enabled_for_disk_encryption = true
      soft_delete_retention_days  = 7
      purge_protection_enabled    = true
      keyvault_sku                = "standard"
    }
    prod = {
      name                        = "kv-argo-prod-we-001"
      enabled_for_disk_encryption = true
      soft_delete_retention_days  = 30
      purge_protection_enabled    = true
      keyvault_sku                = "premium"
    }
  }
}
resource "azurerm_key_vault" "kv_argo" {
  name                        = local.kv_argo[var.environment].name
  resource_group_name         = var.resource_group_name
  location                    = var.azure_region
  enabled_for_disk_encryption = local.kv_argo[var.environment].enabled_for_disk_encryption
  tenant_id                   = var.tenant_id
  soft_delete_retention_days  = local.kv_argo[var.environment].soft_delete_retention_days
  purge_protection_enabled    = local.kv_argo[var.environment].purge_protection_enabled

  sku_name = local.kv_argo[var.environment].keyvault_sku

}
