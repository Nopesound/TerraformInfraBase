terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      version               = "~> 3.0"
      configuration_aliases = [azurerm.src]
    }
        mssql = {
      source  = "betr-io/mssql"
      version = "~> 0.3"
    }
  }
}
