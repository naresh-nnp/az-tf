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

locals {
  alpha_address_prefix   = cidrsubnet(var.base_address_space, 8, 1)
  beta_address_prefix    = cidrsubnet(var.base_address_space, 8, 2)
  charlie_address_prefix = cidrsubnet(var.base_address_space, 8, 3)
}

resource "azurerm_virtual_network" "main" {
  name                = "vnet-${var.application_name}"
  address_space       = [var.base_address_space]
  location            = data.azurerm_resource_group.lab-rg.location
  resource_group_name = data.azurerm_resource_group.lab-rg.name
}
resource "azurerm_subnet" "alpha" {
  name                 = "subnet-${var.application_name}-alpha"
  resource_group_name  = data.azurerm_resource_group.lab-rg.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.alpha_address_prefix]
}
resource "azurerm_subnet" "beta" {
  name                 = "subnet-${var.application_name}-beta"
  resource_group_name  = data.azurerm_resource_group.lab-rg.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.beta_address_prefix]
}
resource "azurerm_subnet" "charlie" {
  name                 = "subnet-${var.application_name}-charlie"
  resource_group_name  = data.azurerm_resource_group.lab-rg.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [local.charlie_address_prefix]

}


