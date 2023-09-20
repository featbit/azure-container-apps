output "vnet_id" {
  value = azurerm_virtual_network.featbit_vnet.id
}

output "vnet_name" {
  value = azurerm_virtual_network.featbit_vnet.name
}

output "subnet_redis_id" {
  value = azurerm_subnet.featbit_redis.id
}

output "subnet_aca_id" {
  value = azurerm_subnet.featbit_container_apps.id
}

output "subnet_mongodb_id" {
  value = azurerm_subnet.featbit_mongodb.id
}

output "subnet_mongodb_name" {
  value = azurerm_subnet.featbit_mongodb.name
}

output "vnet_address_space" {
  value = azurerm_virtual_network.featbit_vnet.address_space
}

output "subnet_mongo_name" {
  value = azurerm_subnet.featbit_mongodb.name
}

output "subnet_prefixes" {
  value = azurerm_subnet.featbit_mongodb.address_prefixes
}