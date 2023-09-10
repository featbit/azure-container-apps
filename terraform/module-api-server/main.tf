

# resource "azurerm_container_app" "api_server" {
#   name                         = var.container_app_name
#   container_app_environment_id = azurerm_container_app_environment.featbit.id
#   resource_group_name          = azurerm_resource_group.featbit.name
#   revision_mode                = "Single"
#   ingress {
#     allow_insecure_connections = true
#     target_port = 5000
#     external_enabled = true
#     traffic_weight {
#       percentage = 100
#     }
#   }

#   template {
#     min_replicas = 1
#     max_replicas = 3

#     container {
#       name   = var.container_name.api_server
#       image  = "docker.io/featbit/featbit-api-server:latest"
#       cpu    = 0.75
#       memory = "1.5Gi"
#       env {
#         name  = "MongoDb__ConnectionString"
#         value = var.mongodb.connection_str
#       }
#       env {
#         name  = "MongoDb__Database"
#         value = var.mongodb.db_name
#       }
#       env {
#         name  = "Redis__ConnectionString"
#         value = azurerm_redis_cache.featbit.primary_connection_string
#       }
#       env {
#         name  = "OLAP__ServiceHost"
#         value = "http://da-server"
#       }
#     }
#   }

#   depends_on = [
#     azurerm_container_app.da_server,
#     azurerm_redis_cache.featbit
#   ]
# }