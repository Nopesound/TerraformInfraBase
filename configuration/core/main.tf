terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    mssql = {
      source  = "betr-io/mssql"
      version = "~> 0.3"
    }
  }

  backend "azurerm" {
    # resource_group_name  = "rg_states"
    # storage_account_name = "saargostates"
    # container_name       = "tfstates"
    # key                  = "terraform.tfstate"
  }

  required_version = ">= 1.1.2"
}
provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }

  subscription_id            = var.subscription_id
  client_id                  = var.client_id
  tenant_id                  = var.tenant_id
  skip_provider_registration = "true"
}
provider "mssql" {
  # Configuration options
}
locals {
  environment = terraform.workspace
  resource_group_name = {
    dev  = "rg-dev-infra"
    test = "rg-test-infra"
    prod = "rg-prod-infra"
  }

}

data "azurerm_resource_group" "rg_main" {
  name = local.resource_group_name[local.environment]
}

module "key_vault" {
  source              = "../../modules/key-vault"
  providers = {
    azurerm.src = azurerm
  }
  resource_group_name = data.azurerm_resource_group.rg_main.name
  environment         = local.environment
  azure_region        = var.azure_region
  tenant_id           = var.tenant_id
}

module "web-app" {
  source              = "../../modules/web-app"
  providers = {
    azurerm.src = azurerm
  }
  resource_group_name = data.azurerm_resource_group.rg_main.name
  environment        = local.environment
  azure_region        = var.azure_region  
}
module "database" {
  source              = "../../modules/database"
  providers = {
    azurerm.src = azurerm
  }
  resource_group_name = data.azurerm_resource_group.rg_main.name
  environment = local.environment
  azure_region        = var.azure_region
  sql_admin_psw       = var.sql_admin_psw
  sql_dbuser_argo_password = var.sql_dbuser_argo_password
  kv_argo_id          = module.key_vault.kv_argo_id
  depends_on = [ module.key_vault ]
}