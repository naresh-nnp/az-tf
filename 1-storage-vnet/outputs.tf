output "resouce_group_name" {
  value = data.azurerm_resource_group.lab-rg.name
}
output "rg_location" {
  value = data.azurerm_resource_group.lab-rg.location
}
output "storage_account_name" {
  value = azurerm_storage_account.example.name
}
output "network_name" {
  value = azurerm_virtual_network.main.name
}
output "subnet_1_name" {
  value = azurerm_subnet.alpha.name
}
output "subnet_2_name" {
  value = azurerm_subnet.beta.name
}
output "subnet_3_name" {
  value = azurerm_subnet.charlie.name
}
