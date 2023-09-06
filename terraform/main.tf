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

resource "azurerm_container_app" "api_server" {
  name                         = var.container_name.api
  container_app_environment_id = azurerm_container_app_environment.featbit.id
  resource_group_name          = azurerm_resource_group.featbit.name
  revision_mode                = "Single"

  template {
    container {
      name   = var.container_name.api
      image  = "docker.io/featbit/featbit-ui:latest"
      cpu    = 0.25
      memory = "0.5Gi"
      env {
        name = "MongoDb__ConnectionString"
        value = "mongodb://admin:password@mongodb:27017"
      }
      env {
        name = "MongoDb__Database"
        value = "featbit"
      }
      env {
        name = "Redis__ConnectionString"
        value = "redis:6379"
      }
      env {
        name = "OLAP__ServiceHost"
        value = "http://da-server"
      }
    }
  }
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
