terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 5.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.9.0"
    }
  }
}
provider "azurerm" {
  features {}
  subscription_id = "0cfe2870-d256-4119-b0a3-16293ac11bdc"
}
