output "mongodb_primary_key" {
  sensitive = true
  value     = azurerm_cosmosdb_account.featbit.primary_key
}

output "mongodb_primary_sql_connection_string" {
  sensitive = true
  value     = try([for c in jsondecode(data.azapi_resource_action.cosmosdb_featbit_connection_strings.output).connectionStrings : c.connectionString if c.description == "Primary MongoDB Connection String"][0], "")
}

output "mongodb_secondary_mongodb_connection_string" {
  sensitive = true
  value     = try([for c in jsondecode(data.azapi_resource_action.cosmosdb_featbit_connection_strings.output).connectionStrings : c.connectionString if c.description == "Secondary MongoDB Connection String"][0], "")
}

output "mongodb_primary_readonly_mongodb_connection_string" {
  sensitive = true
  value     = try([for c in jsondecode(data.azapi_resource_action.cosmosdb_featbit_connection_strings.output).connectionStrings : c.connectionString if c.description == "Primary Read-Only MongoDB Connection String"][0], "")
}

output "mongodb_secondary_readonly_mongodb_connection_string" {
  sensitive = true
  value     = try([for c in jsondecode(data.azapi_resource_action.cosmosdb_featbit_connection_strings.output).connectionStrings : c.connectionString if c.description == "Secondary Read-Only MongoDB Connection String"][0], "")
}