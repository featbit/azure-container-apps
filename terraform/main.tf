# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.71.0"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_redis_cache" "featbit" {
  # count = var.redis.if_has_redis ? 1 : 0

  name                = "featbit-redis"
  location            = azurerm_resource_group.featbit.location
  resource_group_name = azurerm_resource_group.featbit.name
  capacity            = var.redis.capacity
  family              = var.redis.family
  sku_name            = var.redis.sku_name
  enable_non_ssl_port = var.redis.enable_non_ssl_port
  minimum_tls_version = var.redis.minimum_tls_version

  redis_configuration {
  }
}

# output "featbit_redis" {
#   value = azurerm_redis_cache.featbit
# }

resource "azurerm_virtual_network" "featbit_vnet" {

  name                = "featbit-vnet"
  resource_group_name = azurerm_resource_group.featbit.name
  location            = azurerm_resource_group.featbit.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "featbit_redis" {

  name                 = "featbit-redis-subnet"
  resource_group_name  = azurerm_resource_group.featbit.name
  virtual_network_name = azurerm_virtual_network.featbit_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_private_endpoint" "featbit_redis_pe" {

  name                = "featbitRedisPrivateEndpoint"
  location            = azurerm_resource_group.featbit.location
  resource_group_name = azurerm_resource_group.featbit.name
  subnet_id           = azurerm_subnet.featbit_redis.id

  private_service_connection {
    name                           = "featbitRedisPrivateServiceConnection"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_redis_cache.featbit.id
    subresource_names               = [ "redisCache" ]
  }
}

# Optional
# resource "azurerm_log_analytics_workspace" "featbit" {
#   name                = "acctest-01"
#   location            = azurerm_resource_group.featbit.location
#   resource_group_name = azurerm_resource_group.featbit.name
#   sku                 = "PerGB2018"
#   retention_in_days   = 30
# }

resource "azurerm_container_app_environment" "featbit" {
  name                = var.container_apps_environment
  location            = azurerm_resource_group.featbit.location
  resource_group_name = azurerm_resource_group.featbit.name
  # log_analytics_workspace_id = azurerm_log_analytics_workspace.featbit.id
}

resource "azurerm_container_app" "da_server" {
  name                         = var.container_name.da_server
  container_app_environment_id = azurerm_container_app_environment.featbit.id
  resource_group_name          = azurerm_resource_group.featbit.name
  revision_mode                = "Single"

  template {
    min_replicas = 1
    max_replicas = 3
    container {
      name   = var.container_name.da_server
      image  = "docker.io/featbit/featbit-data-analytics-server:latest"
      cpu    = 0.25
      memory = "0.5Gi"
      env {
        name  = "REDIS_URL"
        # value = var.redis.if_has_redis ? azurerm_redis_cache.featbit.primary_connection_string : var.redis.connection_str
        value = azurerm_redis_cache.featbit.primary_connection_string
      }
      env {
        name  = "MONGO_URI"
        value = var.mongodb.connection_str
      }
      env {
        name  = "MONGO_INITDB_DATABASE"
        value = var.mongodb.db_name
      }
      env {
        name  = "MONGO_HOST"
        value = "mongodb"
      }
    }
  }
}

resource "azurerm_container_app" "api_server" {
  name                         = var.container_name.api_server
  container_app_environment_id = azurerm_container_app_environment.featbit.id
  resource_group_name          = azurerm_resource_group.featbit.name
  revision_mode                = "Single"

  template {
    min_replicas = 1
    max_replicas = 3
    container {
      name         = var.container_name.api_server
      image        = "docker.io/featbit/featbit-api-server:latest"
      cpu          = 0.25
      memory       = "0.5Gi"
      env {
        name  = "MongoDb__ConnectionString"
        value = var.mongodb.connection_str
      }
      env {
        name  = "MongoDb__Database"
        value = var.mongodb.db_name
      }
      env {
        name  = "Redis__ConnectionString"
        value = var.redis.if_has_redis ? azurerm_redis_cache.featbit.primary_connection_string : var.redis.connection_str
      }
      env {
        name  = "OLAP__ServiceHost"
        value = "http://da-server"
      }
    }
  }

  depends_on = [
    azurerm_container_app.da_server
  ]
}

# resource "azurerm_container_app" "ui" {
#   name                         = var.container_name.ui
#   container_app_environment_id = azurerm_container_app_environment.featbit.id
#   resource_group_name          = azurerm_resource_group.featbit.name
#   revision_mode                = "Single"

#   template {
#     container {
#       name   = var.container_name.ui
#       image  = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
#       cpu    = 0.25
#       memory = "0.5Gi"
#     }
#   }

#   depends_on = [
#     azurerm_container_app.api_server
#   ]
# }
