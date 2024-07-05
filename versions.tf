/*
  Claranet Azure module version constraints
  https://registry.terraform.io/modules/claranet/cdn-frontdoor/azurerm/7.4.0#global-versioning-rule-for-claranet-azure-modules
*/
terraform {
  required_version = ">= 1.3"
  #backend "azurerm" {}

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.110"
    }
  }
}

provider "azurerm" {
  features {}
}
