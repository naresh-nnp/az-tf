data "azurerm_resource_group" "lab-rg" {
  name = var.resource_group_name
}
resource "azurerm_public_ip" "vm1-pip" {
  name                = "vm1-publicip"
  resource_group_name = data.azurerm_resource_group.lab-rg.name
  location            = data.azurerm_resource_group.lab-rg.location
  allocation_method   = "Static"
}

data "azurerm_subnet" "alpha" { //vnet & subnet are created in 1.1-vnet lab, so the subnet is already provisioned
  name                 = "subnet-alpha"
  virtual_network_name = "nnp-network-inventory"
  resource_group_name  = data.azurerm_resource_group.lab-rg.name
}

resource "azurerm_network_interface" "vm1-nic" {
  name                = "vm1-nic-card"
  location            = data.azurerm_resource_group.lab-rg.location
  resource_group_name = data.azurerm_resource_group.lab-rg.name

  ip_configuration {
    name                          = "vm1-nic-ip-config"
    subnet_id                     = data.azurerm_subnet.alpha.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm1-pip.id
  }
}
# RSA key of size 4096 bits
resource "tls_private_key" "vm1" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "local_file" "private_key" {
  content         = tls_private_key.vm1.private_key_pem
  filename        = pathexpand("~/.ssh/vm1")
  file_permission = "0600"
}

resource "local_file" "public_key" {
  content  = tls_private_key.vm1.public_key_openssh
  filename = pathexpand("~/.ssh/vm1.pub")
}
resource "azurerm_linux_virtual_machine" "vm1" {
  name                = "vm1"
  resource_group_name = data.azurerm_resource_group.lab-rg.name
  location            = data.azurerm_resource_group.lab-rg.location
  size                = "Standard_D2s_v3"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.vm1-nic.id
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = tls_private_key.vm1.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
