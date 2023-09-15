output "primary_access_key" {
  value = azurerm_redis_cache.featbit.primary_access_key
  sensitive = true
}

output "hostname" {
  value = azurerm_redis_cache.featbit.hostname
  sensitive = true
}

output "ssl_port" {
  value = azurerm_redis_cache.featbit.ssl_port
  sensitive = true
}

output "primary_connection_string" {
  value = azurerm_redis_cache.featbit.primary_connection_string
  sensitive = true
}