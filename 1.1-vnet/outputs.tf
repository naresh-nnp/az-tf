output "network-name" {
    value = azurerm_virtual_network.main.name
}
output "network-address_space" {
    value = azurerm_virtual_network.main.address_space
}
output "subnet_names" {
    value = local.address_prefixes
}
output "nsg-ssh-allow" {
    value = azurerm_network_security_group.allow-ssh-nsg.name
}
output "nsg-ssh-associated-subnet" {
    value = {
        subnet_name = azurerm_subnet.subnets["alpha"].name
        nsg_name = azurerm_network_security_group.allow-ssh-nsg.name
    }
}