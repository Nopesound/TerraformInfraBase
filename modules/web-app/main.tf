locals {
  environment = terraform.workspace
  resource_group_name = {
    dev  = "rg-dev-infra"
    test = "rg-test-infra"
    prod = "rg-prod-infra"
  }
  fe_plan_app = {
    dev = {
      skuname = "F1",
      name    = "sp-wa-argo-we-dev-001"
      os_type = "Linux"
    },
    test = {
      skuname = "S1",
      name    = "sp-wa-argo-we-test-001"
      os_type = "Linux"
    },
    prod = {
      skuname = "S1",
      name    = "sp-wa-argo-we-prod-001"
      os_type = "Linux"
    }
  }
  fe_app = {
    dev = {
      name                          = "as-argo-we-dev-001"
      enabled                       = true
      https_only                    = true
      public_network_access_enabled = true
    },
    test = {
      name                          = "as-argo-we-test-001"
      enabled                       = true
      https_only                    = true
      public_network_access_enabled = true
    },
    prod = {
      name                          = "as-argo-we-prod-001"
      enabled                       = true
      https_only                    = true
      public_network_access_enabled = true
    }
  }
}

resource "azurerm_service_plan" "fe_plan_app" {
  name                = local.fe_plan_app[local.environment].name
  resource_group_name = var.resource_group_name
  location            = var.azure_region
  os_type             = local.fe_plan_app[local.environment].os_type
  sku_name            = local.fe_plan_app[local.environment].skuname
}
resource "azurerm_linux_web_app" "fe_app" {
  name                = local.fe_app[local.environment].name
  resource_group_name = var.resource_group_name
  location            = var.azure_region
  service_plan_id     = azurerm_service_plan.fe_plan_app.id
  enabled                       = local.fe_app[local.environment].enabled
  https_only                    = local.fe_app[local.environment].https_only
  public_network_access_enabled = local.fe_app[local.environment].public_network_access_enabled

  site_config {
  }
}
