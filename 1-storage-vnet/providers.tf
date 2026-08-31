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
  subscription_id = "28e1e42a-4438-4c30-9a5f-7d7b488fd883"
}
