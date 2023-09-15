
resource "azurerm_redis_cache" "featbit" {
  name                          = "featbit-redis"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  capacity                      = var.redis.capacity
  family                        = var.redis.family
  sku_name                      = var.redis.sku_name
  enable_non_ssl_port           = var.redis.enable_non_ssl_port
  minimum_tls_version           = var.redis.minimum_tls_version
  public_network_access_enabled = var.redis.public_network_access_enabled

  redis_configuration {
  }
}

resource "azurerm_private_endpoint" "featbit_redis_pe" {
  name                = "featbitRedisPrivateEndpoint"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_redis_id

  private_service_connection {
    name                           = "featbitRedisPrivateServiceConnection"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_redis_cache.featbit.id
    subresource_names              = ["redisCache"]
  }
}

resource "azurerm_private_dns_zone" "pdz" {
  name                = "privatelink.redis.cache.windows.net"
  resource_group_name = azurerm_private_endpoint.featbit_redis_pe.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnetlink_private" {
  name                  = "mydnslink"
  private_dns_zone_name = azurerm_private_dns_zone.pdz.name
  resource_group_name   = azurerm_private_dns_zone.pdz.resource_group_name
  virtual_network_id    = var.vnet_id
}

# Re-matching with fqdn is a good way to make sure the ip you're reading is for the target.
locals {
  redis_server = [
    for c in azurerm_private_endpoint.featbit_redis_pe.custom_dns_configs : c.ip_addresses[0]
    if c.fqdn == "${azurerm_redis_cache.featbit.name}.redis.cache.windows.net"
  ][0]
}

resource "azurerm_private_dns_a_record" "redis" {
  name                = azurerm_redis_cache.featbit.name
  records             = [local.redis_server]
  resource_group_name = azurerm_redis_cache.featbit.resource_group_name
  ttl                 = 3600
  zone_name           = azurerm_private_dns_zone.pdz.name
}
