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

resource "azurerm_resource_group" "featbit" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Team = "FeatBit"
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
    container {
      name   = var.container_name.da_server
      image  = "docker.io/featbit/featbit-data-analytics-server:latest"
      cpu    = 0.25
      memory = "0.5Gi"
      min_replicas = 1
      max_replicas = 3
      env {
        name = "REDIS_URL"
        value = var.redis.connection_str
      }
      env {
        name = "MONGO_URI"
        value =var.mongodb.connection_str
      }
      env {
        name = "MONGO_INITDB_DATABASE"
        value = var.mongodb.db_name
      }
      env {
        name = "MONGO_HOST"
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
    container {
      name   = var.container_name.api_server
      image  = "docker.io/featbit/featbit-api-server:latest"
      cpu    = 0.25
      memory = "0.5Gi"
      min_replicas = 1
      max_replicas = 3
      env {
        name = "MongoDb__ConnectionString"
        value = var.mongodb.connection_str
      }
      env {
        name = "MongoDb__Database"
        value = var.mongodb.db_name
      }
      env {
        name = "Redis__ConnectionString"
        value = var.redis.connection_str
      }
      env {
        name = "OLAP__ServiceHost"
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
