data "azurerm_resource_group" "lab-rg" {
  name = var.resource_group_name
}
resource "azurerm_public_ip" "vm1-pip" {
  name                = "vm1-publicip"
  resource_group_name = data.azurerm_resource_group.lab-rg.name
  location            = data.azurerm_resource_group.lab-rg.location
  allocation_method   = "Static"
}

data "azurerm_subnet" "alpha" {
  name                 = "subnet-alpha"
  virtual_network_name = "nnp-network-inventory"
  resource_group_name  = data.azurerm_resource_group.lab-rg.name
}

resource "azurerm_network_interface" "vm1-nic" {
  name                = "vm1-nic-card"
  location            = data.azurerm_resource_group.lab-rg.location
  resource_group_name = data.azurerm_resource_group.lab-rg.name

  ip_configuration {
    name                          = "public"
    subnet_id                     = data.azurerm_subnet.alpha.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm1-pip.id
  }
}
