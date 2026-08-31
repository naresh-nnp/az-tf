resource "random_string" "suffix" {
  length  = 5
  upper   = false
  special = false
}

data "azurerm_resource_group" "lab-rg" {
  name = var.resource_group_name
}

resource "azurerm_storage_account" "example" {
  name                     = "st${var.application_name}${random_string.suffix.result}"
  resource_group_name      = data.azurerm_resource_group.lab-rg.name
  location                 = data.azurerm_resource_group.lab-rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}
