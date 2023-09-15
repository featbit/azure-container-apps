output "vnet_id" {
  value = azurerm_virtual_network.featbit_vnet.id
  sensitive = true
}

output "vnet_name" {
  value = azurerm_virtual_network.featbit_vnet.name
  sensitive = true
}

output "subnet_redis_id" {
  value = azurerm_subnet.featbit_redis.id
  sensitive = true
}

output "subnet_aca_id" {
  value = azurerm_subnet.featbit_container_apps.id
  sensitive = true
}

output "subnet_mongodb_id" {
  value = azurerm_subnet.featbit_mongodb.id
  sensitive = true
}

output "subnet_mongodb_name" {
  value = azurerm_subnet.featbit_mongodb.name
  sensitive = true
}

output "vnet_address_space" {
  value = azurerm_virtual_network.featbit_vnet.address_space
  sensitive = true
}

output "subnet_mongo_name" {
  value = azurerm_subnet.featbit_mongodb.name
  sensitive = true
}

output "subnet_prefixes" {
  value = azurerm_subnet.featbit_mongodb.address_prefixes
  sensitive = true
}