resource "random_string" "suffix" {
  length  = 5
  upper   = false
  special = false
}

data "azurerm_resource_group" "lab-rg" {
  name = var.resource_group_name
}

locals {
  subnet_names = ["alpha", "beta", "charlie"]

  address_prefixes = {
    for index, name in local.subnet_names :
    name => cidrsubnet(var.base_address_space, 8, index + 1)
  }
}

resource "azurerm_virtual_network" "main" {
  name                = "nnp-network-${var.application_name}"
  location            = data.azurerm_resource_group.lab-rg.location
  resource_group_name = data.azurerm_resource_group.lab-rg.name
  address_space       = [var.base_address_space]
}

resource "azurerm_subnet" "subnets" {
  for_each             = local.address_prefixes
  name                 = "subnet-${each.key}"
  resource_group_name  = data.azurerm_resource_group.lab-rg.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [each.value]
}

resource "azurerm_network_security_group" "allow-ssh-nsg" {
  name                = "nsg-${var.application_name}-ssh"
  location            = data.azurerm_resource_group.lab-rg.location
  resource_group_name = data.azurerm_resource_group.lab-rg.name

  security_rule {
    name                       = "allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = chomp(data.http.my-ip.response_body) //chomp->is a terraform function which strip off any unnecessary new lines or whitespaces
    destination_address_prefix = "*"
  }
}
resource "azurerm_subnet_network_security_group_association" "alpha-remote_access" {
  subnet_id                 = azurerm_subnet.subnets["alpha"].id
  network_security_group_id = azurerm_network_security_group.allow-ssh-nsg.id
}

data "http" "my-ip" {
  url = "https://ifconfig.me/ip"
}
