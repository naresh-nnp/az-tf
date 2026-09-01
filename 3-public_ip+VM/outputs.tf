output "vm1_public_ip" {
  value = azurerm_public_ip.vm1-pip.ip_address
}
output "vm-name" {
  value = azurerm_linux_virtual_machine.vm1.name
}
output "vm1-ip" {
  value = azurerm_linux_virtual_machine.vm1.private_ip_address
}
