output "rg_name" {
  value = azurerm_resource_group.my_rg.name
}

output "sa_name" {
  value = azurerm_storage_account.my_sa.name
}
