terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    mssql = {
      source  = "betr-io/mssql"
      version = "0.2.4"
    }
  }

  backend "azurerm" {}

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
