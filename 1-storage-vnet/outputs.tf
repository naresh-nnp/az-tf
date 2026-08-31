output "resouce_group_name" {
  value = data.azurerm_resource_group.lab-rg.name
}
output "rg_location" {
  value = data.azurerm_resource_group.lab-rg.location
}
output "storage_account_name" {
  value = azurerm_storage_account.example.name
}

