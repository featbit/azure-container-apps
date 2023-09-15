resource "azurerm_virtual_network" "featbit_vnet" {
  name                = "featbit-vnet"
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = ["192.168.0.0/16"]
}

resource "azurerm_subnet" "featbit_redis" {
  name                 = "featbit-redis-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.featbit_vnet.name
  address_prefixes     = [cidrsubnet("192.168.0.0/16", 7, 0)]
}

resource "azurerm_subnet" "featbit_container_apps" {
  address_prefixes     = [cidrsubnet("192.168.0.0/16", 7, 1)]
  name                 = "featbit-containerapps-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.featbit_vnet.name
}

resource "azurerm_subnet" "featbit_mongodb" {
  address_prefixes                               = [cidrsubnet("192.168.0.0/16", 7, 2)]
  name                                           = "featbit-mongodb-subnet"
  resource_group_name                            = var.resource_group_name
  virtual_network_name                           = azurerm_virtual_network.featbit_vnet.name
}