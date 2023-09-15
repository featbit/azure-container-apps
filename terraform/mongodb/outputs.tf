output "mongodb_primary_key" {
  value = azurerm_cosmosdb_account.featbit.primary_key
  sensitive = true
}

output "mongodb_primary_sql_connection_string" {
  value = azurerm_cosmosdb_account.featbit.primary_sql_connection_string 
  sensitive = true
}