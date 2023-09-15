resource "azurerm_resource_group" "res-0" {
  location = "westeurope"
  name     = "featbit-tio-rg"
  tags = {
    Team = "FeatBit"
  }
}
resource "azurerm_container_app" "res-1" {
  container_app_environment_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.App/managedEnvironments/featbit-environment"
  name                         = "api-server"
  resource_group_name          = "featbit-tio-rg"
  revision_mode                = "Single"
  ingress {
    allow_insecure_connections = true
    external_enabled           = true
    target_port                = 5000
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
  template {
    max_replicas = 3
    container {
      cpu    = 0.75
      image  = "docker.io/featbit/featbit-api-server:latest"
      memory = "1.5Gi"
      name   = "api-server"
      env {
        name  = "MongoDb__ConnectionString"
        value = "mongodb://featbit-mongodb:tDsgxR2LqzyxvxSYregxIcZCZ6fbNprW1yM2Zu66cQiwFoi3I3TEvkKTGlDJDLw2xBXn4ppwr0kvACDbhjvoRg==@featbit-mongodb.mongo.cosmos.azure.com:10255/?ssl=true&replicaSet=globaldb&retrywrites=false&maxIdleTimeMS=120000&appName=@featbit-mongodb@"
      }
      env {
        name  = "MongoDb__Database"
        value = "featbit"
      }
      env {
        name  = "Redis__ConnectionString"
        value = "featbit-redis.redis.cache.windows.net:6380,password=F9TtL5qUX6Ybv8tramDE8sMTU6jeXE0UIAzCaDts5X0=,ssl=true,abortConnect=False"
      }
      env {
        name  = "OLAP__ServiceHost"
        value = "http://da-server"
      }
    }
  }
  depends_on = [
    azurerm_container_app_environment.res-5,
  ]
}
resource "azurerm_container_app" "res-2" {
  container_app_environment_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.App/managedEnvironments/featbit-environment"
  name                         = "da-server"
  resource_group_name          = "featbit-tio-rg"
  revision_mode                = "Single"
  ingress {
    allow_insecure_connections = true
    target_port                = 80
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
  template {
    max_replicas = 3
    container {
      cpu    = 0.75
      image  = "docker.io/featbit/featbit-data-analytics-server:latest"
      memory = "1.5Gi"
      name   = "da-server"
      env {
        name  = "REDIS_URL"
        value = "rediss://default:F9TtL5qUX6Ybv8tramDE8sMTU6jeXE0UIAzCaDts5X0=@featbit-redis.redis.cache.windows.net:6380"
      }
      env {
        name  = "MONGO_URI"
        value = "mongodb://featbit-mongodb:tDsgxR2LqzyxvxSYregxIcZCZ6fbNprW1yM2Zu66cQiwFoi3I3TEvkKTGlDJDLw2xBXn4ppwr0kvACDbhjvoRg==@featbit-mongodb.mongo.cosmos.azure.com:10255/?ssl=true&replicaSet=globaldb&retrywrites=false&maxIdleTimeMS=120000&appName=@featbit-mongodb@"
      }
      env {
        name  = "MONGO_INITDB_DATABASE"
        value = "featbit"
      }
      env {
        name  = "MONGO_HOST"
        value = "mongodb"
      }
      env {
        name  = "CHECK_DB_LIVNESS"
        value = "false"
      }
      env {
        name  = "mongodb_primary_key"
        value = "tDsgxR2LqzyxvxSYregxIcZCZ6fbNprW1yM2Zu66cQiwFoi3I3TEvkKTGlDJDLw2xBXn4ppwr0kvACDbhjvoRg=="
      }
      env {
        name = "mongodb_primary_sql_connection_string"
      }
    }
  }
  depends_on = [
    azurerm_container_app_environment.res-5,
  ]
}
resource "azurerm_container_app" "res-3" {
  container_app_environment_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.App/managedEnvironments/featbit-environment"
  name                         = "evaluation-server"
  resource_group_name          = "featbit-tio-rg"
  revision_mode                = "Single"
  ingress {
    allow_insecure_connections = true
    external_enabled           = true
    target_port                = 5100
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
  template {
    max_replicas = 3
    container {
      cpu    = 0.75
      image  = "docker.io/featbit/featbit-evaluation-server:latest"
      memory = "1.5Gi"
      name   = "evaluation-server"
      env {
        name  = "MongoDb__ConnectionString"
        value = "mongodb://featbit-mongodb:tDsgxR2LqzyxvxSYregxIcZCZ6fbNprW1yM2Zu66cQiwFoi3I3TEvkKTGlDJDLw2xBXn4ppwr0kvACDbhjvoRg==@featbit-mongodb.mongo.cosmos.azure.com:10255/?ssl=true&replicaSet=globaldb&retrywrites=false&maxIdleTimeMS=120000&appName=@featbit-mongodb@"
      }
      env {
        name  = "MongoDb__Database"
        value = "featbit"
      }
      env {
        name  = "Redis__ConnectionString"
        value = "featbit-redis.redis.cache.windows.net:6380,password=F9TtL5qUX6Ybv8tramDE8sMTU6jeXE0UIAzCaDts5X0=,ssl=true,abortConnect=False"
      }
    }
  }
  depends_on = [
    azurerm_container_app_environment.res-5,
  ]
}
resource "azurerm_container_app" "res-4" {
  container_app_environment_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.App/managedEnvironments/featbit-environment"
  name                         = "ui"
  resource_group_name          = "featbit-tio-rg"
  revision_mode                = "Single"
  ingress {
    external_enabled = true
    target_port      = 80
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
  template {
    max_replicas = 3
    container {
      cpu    = 0.5
      image  = "featbit/featbit-ui:latest"
      memory = "1Gi"
      name   = "ui"
      env {
        name  = "API_URL"
        value = "https://api-server.calmtree-5ffe45e6.westeurope.azurecontainerapps.io"
      }
      env {
        name  = "DEMO_URL"
        value = "https://featbit-samples.vercel.app"
      }
      env {
        name  = "EVALUATION_URL"
        value = "https://evaluation-server.calmtree-5ffe45e6.westeurope.azurecontainerapps.io"
      }
    }
  }
  depends_on = [
    azurerm_container_app_environment.res-5,
  ]
}
resource "azurerm_container_app_environment" "res-5" {
  infrastructure_subnet_id   = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.Network/virtualNetworks/featbit-vnet/subnets/featbit-containerapps-subnet"
  location                   = "westeurope"
  log_analytics_workspace_id = ""
  name                       = "featbit-environment"
  resource_group_name        = "featbit-tio-rg"
  depends_on = [
    azurerm_subnet.res-41,
  ]
}
resource "azurerm_redis_cache" "res-6" {
  capacity                      = 0
  family                        = "C"
  location                      = "westeurope"
  name                          = "featbit-redis"
  public_network_access_enabled = false
  resource_group_name           = "featbit-tio-rg"
  sku_name                      = "Basic"
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_cosmosdb_account" "res-8" {
  enable_automatic_failover = true
  kind                      = "MongoDB"
  location                  = "westeurope"
  name                      = "featbit-mongodb"
  offer_type                = "Standard"
  resource_group_name       = "featbit-tio-rg"
  consistency_policy {
    consistency_level = "BoundedStaleness"
  }
  geo_location {
    failover_priority = 0
    location          = "westeurope"
  }
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_cosmosdb_mongo_database" "res-9" {
  account_name        = "featbit-mongodb"
  name                = "featbit"
  resource_group_name = "featbit-tio-rg"
  autoscale_settings {
  }
  depends_on = [
    azurerm_cosmosdb_account.res-8,
  ]
}
resource "azurerm_cosmosdb_mongo_collection" "res-10" {
  account_name        = "featbit-mongodb"
  database_name       = "featbit"
  name                = "AccessTokens"
  resource_group_name = "featbit-tio-rg"
  index {
    keys   = ["_id"]
    unique = true
  }
  index {
    keys = ["createdAt"]
  }
  depends_on = [
    azurerm_cosmosdb_mongo_database.res-9,
  ]
}
resource "azurerm_cosmosdb_mongo_collection" "res-11" {
  account_name        = "featbit-mongodb"
  database_name       = "featbit"
  name                = "AuditLogs"
  resource_group_name = "featbit-tio-rg"
  index {
    keys   = ["_id"]
    unique = true
  }
  index {
    keys = ["createdAt"]
  }
  depends_on = [
    azurerm_cosmosdb_mongo_database.res-9,
  ]
}
resource "azurerm_cosmosdb_mongo_collection" "res-12" {
  account_name        = "featbit-mongodb"
  database_name       = "featbit"
  name                = "EndUserProperties"
  resource_group_name = "featbit-tio-rg"
  index {
    keys   = ["_id"]
    unique = true
  }
  depends_on = [
    azurerm_cosmosdb_mongo_database.res-9,
  ]
}
resource "azurerm_cosmosdb_mongo_collection" "res-13" {
  account_name        = "featbit-mongodb"
  database_name       = "featbit"
  name                = "EndUsers"
  resource_group_name = "featbit-tio-rg"
  index {
    keys   = ["_id"]
    unique = true
  }
  index {
    keys = ["updatedAt"]
  }
  depends_on = [
    azurerm_cosmosdb_mongo_database.res-9,
  ]
}
resource "azurerm_cosmosdb_mongo_collection" "res-14" {
  account_name        = "featbit-mongodb"
  database_name       = "featbit"
  name                = "Environments"
  resource_group_name = "featbit-tio-rg"
  index {
    keys   = ["_id"]
    unique = true
  }
  depends_on = [
    azurerm_cosmosdb_mongo_database.res-9,
  ]
}
resource "azurerm_cosmosdb_mongo_collection" "res-15" {
  account_name        = "featbit-mongodb"
  database_name       = "featbit"
  name                = "Events"
  resource_group_name = "featbit-tio-rg"
  index {
    keys   = ["_id"]
    unique = true
  }
  index {
    keys = ["event", "env_id", "distinct_id", "timestamp"]
  }
  depends_on = [
    azurerm_cosmosdb_mongo_database.res-9,
  ]
}
resource "azurerm_cosmosdb_mongo_collection" "res-16" {
  account_name        = "featbit-mongodb"
  database_name       = "featbit"
  name                = "FeatureFlags"
  resource_group_name = "featbit-tio-rg"
  index {
    keys   = ["_id"]
    unique = true
  }
  index {
    keys = ["updatedAt"]
  }
  depends_on = [
    azurerm_cosmosdb_mongo_database.res-9,
  ]
}
resource "azurerm_cosmosdb_mongo_collection" "res-17" {
  account_name        = "featbit-mongodb"
  database_name       = "featbit"
  name                = "FlagRevisions"
  resource_group_name = "featbit-tio-rg"
  index {
    keys   = ["_id"]
    unique = true
  }
  depends_on = [
    azurerm_cosmosdb_mongo_database.res-9,
  ]
}
resource "azurerm_cosmosdb_mongo_collection" "res-18" {
  account_name        = "featbit-mongodb"
  database_name       = "featbit"
  name                = "MemberPolicies"
  resource_group_name = "featbit-tio-rg"
  index {
    keys   = ["_id"]
    unique = true
  }
  depends_on = [
    azurerm_cosmosdb_mongo_database.res-9,
  ]
}
resource "azurerm_cosmosdb_mongo_collection" "res-19" {
  account_name        = "featbit-mongodb"
  database_name       = "featbit"
  name                = "OrganizationUsers"
  resource_group_name = "featbit-tio-rg"
  index {
    keys   = ["_id"]
    unique = true
  }
  depends_on = [
    azurerm_cosmosdb_mongo_database.res-9,
  ]
}
resource "azurerm_cosmosdb_mongo_collection" "res-20" {
  account_name        = "featbit-mongodb"
  database_name       = "featbit"
  name                = "Organizations"
  resource_group_name = "featbit-tio-rg"
  index {
    keys   = ["_id"]
    unique = true
  }
  depends_on = [
    azurerm_cosmosdb_mongo_database.res-9,
  ]
}
resource "azurerm_cosmosdb_mongo_collection" "res-21" {
  account_name        = "featbit-mongodb"
  database_name       = "featbit"
  name                = "Policies"
  resource_group_name = "featbit-tio-rg"
  index {
    keys   = ["_id"]
    unique = true
  }
  index {
    keys = ["createdAt"]
  }
  depends_on = [
    azurerm_cosmosdb_mongo_database.res-9,
  ]
}
resource "azurerm_cosmosdb_mongo_collection" "res-22" {
  account_name        = "featbit-mongodb"
  database_name       = "featbit"
  name                = "Projects"
  resource_group_name = "featbit-tio-rg"
  index {
    keys   = ["_id"]
    unique = true
  }
  index {
    keys = ["createdAt"]
  }
  depends_on = [
    azurerm_cosmosdb_mongo_database.res-9,
  ]
}
resource "azurerm_cosmosdb_mongo_collection" "res-23" {
  account_name        = "featbit-mongodb"
  database_name       = "featbit"
  name                = "RelayProxies"
  resource_group_name = "featbit-tio-rg"
  index {
    keys   = ["_id"]
    unique = true
  }
  index {
    keys = ["createdAt"]
  }
  depends_on = [
    azurerm_cosmosdb_mongo_database.res-9,
  ]
}
resource "azurerm_cosmosdb_mongo_collection" "res-24" {
  account_name        = "featbit-mongodb"
  database_name       = "featbit"
  name                = "Segments"
  resource_group_name = "featbit-tio-rg"
  index {
    keys   = ["_id"]
    unique = true
  }
  index {
    keys = ["updatedAt"]
  }
  depends_on = [
    azurerm_cosmosdb_mongo_database.res-9,
  ]
}
resource "azurerm_cosmosdb_mongo_collection" "res-25" {
  account_name        = "featbit-mongodb"
  database_name       = "featbit"
  name                = "Users"
  resource_group_name = "featbit-tio-rg"
  index {
    keys   = ["_id"]
    unique = true
  }
  depends_on = [
    azurerm_cosmosdb_mongo_database.res-9,
  ]
}
resource "azurerm_private_dns_zone" "res-28" {
  name                = "privatelink.mongo.cosmos.azure.com"
  resource_group_name = "featbit-tio-rg"
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_private_dns_a_record" "res-29" {
  name                = "featbit-mongodb"
  records             = ["192.168.4.4"]
  resource_group_name = "featbit-tio-rg"
  tags = {
    creator = "created by private endpoint featbit-mongodb-pe with resource guid 03174282-2f06-4bd3-aee1-83f1ee9c1341"
  }
  ttl       = 10
  zone_name = "privatelink.mongo.cosmos.azure.com"
  depends_on = [
    azurerm_private_dns_zone.res-28,
  ]
}
resource "azurerm_private_dns_a_record" "res-30" {
  name                = "featbit-mongodb-westeurope"
  records             = ["192.168.4.5"]
  resource_group_name = "featbit-tio-rg"
  tags = {
    creator = "created by private endpoint featbit-mongodb-pe with resource guid 03174282-2f06-4bd3-aee1-83f1ee9c1341"
  }
  ttl       = 10
  zone_name = "privatelink.mongo.cosmos.azure.com"
  depends_on = [
    azurerm_private_dns_zone.res-28,
  ]
}
resource "azurerm_private_dns_zone_virtual_network_link" "res-32" {
  name                  = "dghmnnkthn5ku"
  private_dns_zone_name = "privatelink.mongo.cosmos.azure.com"
  resource_group_name   = "featbit-tio-rg"
  virtual_network_id    = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.Network/virtualNetworks/featbit-vnet"
  depends_on = [
    azurerm_private_dns_zone.res-28,
    azurerm_virtual_network.res-40,
  ]
}
resource "azurerm_private_dns_zone" "res-33" {
  name                = "privatelink.redis.cache.windows.net"
  resource_group_name = "featbit-tio-rg"
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_private_dns_a_record" "res-34" {
  name                = "featbit-redis"
  records             = ["192.168.0.4"]
  resource_group_name = "featbit-tio-rg"
  ttl                 = 3600
  zone_name           = "privatelink.redis.cache.windows.net"
  depends_on = [
    azurerm_private_dns_zone.res-33,
  ]
}
resource "azurerm_private_dns_zone_virtual_network_link" "res-36" {
  name                  = "mydnslink"
  private_dns_zone_name = "privatelink.redis.cache.windows.net"
  resource_group_name   = "featbit-tio-rg"
  virtual_network_id    = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.Network/virtualNetworks/featbit-vnet"
  depends_on = [
    azurerm_private_dns_zone.res-33,
    azurerm_virtual_network.res-40,
  ]
}
resource "azurerm_private_endpoint" "res-37" {
  custom_network_interface_name = "featbit-mongodb-pe-nic"
  location                      = "westeurope"
  name                          = "featbit-mongodb-pe"
  resource_group_name           = "featbit-tio-rg"
  subnet_id                     = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.Network/virtualNetworks/featbit-vnet/subnets/featbit-mongodb-subnet"
  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = ["/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.Network/privateDnsZones/privatelink.mongo.cosmos.azure.com"]
  }
  private_service_connection {
    is_manual_connection           = false
    name                           = "featbit-mongodb-pe"
    private_connection_resource_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.DocumentDB/databaseAccounts/featbit-mongodb"
    subresource_names              = ["MongoDB"]
  }
  depends_on = [
    azurerm_cosmosdb_account.res-8,
    azurerm_private_dns_zone.res-28,
    azurerm_subnet.res-42,
  ]
}
resource "azurerm_private_endpoint" "res-39" {
  location            = "westeurope"
  name                = "featbitRedisPrivateEndpoint"
  resource_group_name = "featbit-tio-rg"
  subnet_id           = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.Network/virtualNetworks/featbit-vnet/subnets/featbit-redis-subnet"
  private_service_connection {
    is_manual_connection           = false
    name                           = "featbitRedisPrivateServiceConnection"
    private_connection_resource_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.Cache/redis/featbit-redis"
    subresource_names              = ["redisCache"]
  }
  depends_on = [
    azurerm_redis_cache.res-6,
    azurerm_subnet.res-43,
  ]
}
resource "azurerm_virtual_network" "res-40" {
  address_space       = ["192.168.0.0/16"]
  location            = "westeurope"
  name                = "featbit-vnet"
  resource_group_name = "featbit-tio-rg"
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_subnet" "res-41" {
  address_prefixes     = ["192.168.2.0/23"]
  name                 = "featbit-containerapps-subnet"
  resource_group_name  = "featbit-tio-rg"
  virtual_network_name = "featbit-vnet"
  depends_on = [
    azurerm_virtual_network.res-40,
  ]
}
resource "azurerm_subnet" "res-42" {
  address_prefixes     = ["192.168.4.0/23"]
  name                 = "featbit-mongodb-subnet"
  resource_group_name  = "featbit-tio-rg"
  virtual_network_name = "featbit-vnet"
  depends_on = [
    azurerm_virtual_network.res-40,
  ]
}
resource "azurerm_subnet" "res-43" {
  address_prefixes     = ["192.168.0.0/23"]
  name                 = "featbit-redis-subnet"
  resource_group_name  = "featbit-tio-rg"
  virtual_network_name = "featbit-vnet"
  depends_on = [
    azurerm_virtual_network.res-40,
  ]
}
resource "azurerm_log_analytics_workspace" "res-44" {
  location            = "westeurope"
  name                = "acctest-01"
  resource_group_name = "featbit-tio-rg"
  depends_on = [
    azurerm_resource_group.res-0,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-45" {
  category                   = "General Exploration"
  display_name               = "All Computers with their most recent data"
  log_analytics_workspace_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.OperationalInsights/workspaces/acctest-01"
  name                       = "LogManagement(acctest-01)_General|AlphabeticallySortedComputers"
  query                      = "search not(ObjectName == \"Advisor Metrics\" or ObjectName == \"ManagedSpace\") | summarize AggregatedValue = max(TimeGenerated) by Computer | limit 500000 | sort by Computer asc\r\n// Oql: NOT(ObjectName=\"Advisor Metrics\" OR ObjectName=ManagedSpace) | measure max(TimeGenerated) by Computer | top 500000 | Sort Computer // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-44,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-46" {
  category                   = "General Exploration"
  display_name               = "Stale Computers (data older than 24 hours)"
  log_analytics_workspace_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.OperationalInsights/workspaces/acctest-01"
  name                       = "LogManagement(acctest-01)_General|StaleComputers"
  query                      = "search not(ObjectName == \"Advisor Metrics\" or ObjectName == \"ManagedSpace\") | summarize lastdata = max(TimeGenerated) by Computer | limit 500000 | where lastdata < ago(24h)\r\n// Oql: NOT(ObjectName=\"Advisor Metrics\" OR ObjectName=ManagedSpace) | measure max(TimeGenerated) as lastdata by Computer | top 500000 | where lastdata < NOW-24HOURS // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-44,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-47" {
  category                   = "General Exploration"
  display_name               = "Which Management Group is generating the most data points?"
  log_analytics_workspace_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.OperationalInsights/workspaces/acctest-01"
  name                       = "LogManagement(acctest-01)_General|dataPointsPerManagementGroup"
  query                      = "search * | summarize AggregatedValue = count() by ManagementGroupName\r\n// Oql: * | Measure count() by ManagementGroupName // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-44,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-48" {
  category                   = "General Exploration"
  display_name               = "Distribution of data Types"
  log_analytics_workspace_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.OperationalInsights/workspaces/acctest-01"
  name                       = "LogManagement(acctest-01)_General|dataTypeDistribution"
  query                      = "search * | extend Type = $table | summarize AggregatedValue = count() by Type\r\n// Oql: * | Measure count() by Type // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-44,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-49" {
  category                   = "Log Management"
  display_name               = "All Events"
  log_analytics_workspace_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.OperationalInsights/workspaces/acctest-01"
  name                       = "LogManagement(acctest-01)_LogManagement|AllEvents"
  query                      = "Event | sort by TimeGenerated desc\r\n// Oql: Type=Event // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-44,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-50" {
  category                   = "Log Management"
  display_name               = "All Syslogs"
  log_analytics_workspace_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.OperationalInsights/workspaces/acctest-01"
  name                       = "LogManagement(acctest-01)_LogManagement|AllSyslog"
  query                      = "Syslog | sort by TimeGenerated desc\r\n// Oql: Type=Syslog // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-44,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-51" {
  category                   = "Log Management"
  display_name               = "All Syslog Records grouped by Facility"
  log_analytics_workspace_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.OperationalInsights/workspaces/acctest-01"
  name                       = "LogManagement(acctest-01)_LogManagement|AllSyslogByFacility"
  query                      = "Syslog | summarize AggregatedValue = count() by Facility\r\n// Oql: Type=Syslog | Measure count() by Facility // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-44,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-52" {
  category                   = "Log Management"
  display_name               = "All Syslog Records grouped by ProcessName"
  log_analytics_workspace_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.OperationalInsights/workspaces/acctest-01"
  name                       = "LogManagement(acctest-01)_LogManagement|AllSyslogByProcessName"
  query                      = "Syslog | summarize AggregatedValue = count() by ProcessName\r\n// Oql: Type=Syslog | Measure count() by ProcessName // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-44,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-53" {
  category                   = "Log Management"
  display_name               = "All Syslog Records with Errors"
  log_analytics_workspace_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.OperationalInsights/workspaces/acctest-01"
  name                       = "LogManagement(acctest-01)_LogManagement|AllSyslogsWithErrors"
  query                      = "Syslog | where SeverityLevel == \"error\" | sort by TimeGenerated desc\r\n// Oql: Type=Syslog SeverityLevel=error // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-44,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-54" {
  category                   = "Log Management"
  display_name               = "Average HTTP Request time by Client IP Address"
  log_analytics_workspace_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.OperationalInsights/workspaces/acctest-01"
  name                       = "LogManagement(acctest-01)_LogManagement|AverageHTTPRequestTimeByClientIPAddress"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = avg(TimeTaken) by cIP\r\n// Oql: Type=W3CIISLog | Measure Avg(TimeTaken) by cIP // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-44,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-55" {
  category                   = "Log Management"
  display_name               = "Average HTTP Request time by HTTP Method"
  log_analytics_workspace_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.OperationalInsights/workspaces/acctest-01"
  name                       = "LogManagement(acctest-01)_LogManagement|AverageHTTPRequestTimeHTTPMethod"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = avg(TimeTaken) by csMethod\r\n// Oql: Type=W3CIISLog | Measure Avg(TimeTaken) by csMethod // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-44,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-56" {
  category                   = "Log Management"
  display_name               = "Count of IIS Log Entries by Client IP Address"
  log_analytics_workspace_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.OperationalInsights/workspaces/acctest-01"
  name                       = "LogManagement(acctest-01)_LogManagement|CountIISLogEntriesClientIPAddress"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by cIP\r\n// Oql: Type=W3CIISLog | Measure count() by cIP // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-44,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-57" {
  category                   = "Log Management"
  display_name               = "Count of IIS Log Entries by HTTP Request Method"
  log_analytics_workspace_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.OperationalInsights/workspaces/acctest-01"
  name                       = "LogManagement(acctest-01)_LogManagement|CountIISLogEntriesHTTPRequestMethod"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csMethod\r\n// Oql: Type=W3CIISLog | Measure count() by csMethod // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-44,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-58" {
  category                   = "Log Management"
  display_name               = "Count of IIS Log Entries by HTTP User Agent"
  log_analytics_workspace_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.OperationalInsights/workspaces/acctest-01"
  name                       = "LogManagement(acctest-01)_LogManagement|CountIISLogEntriesHTTPUserAgent"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csUserAgent\r\n// Oql: Type=W3CIISLog | Measure count() by csUserAgent // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-44,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-59" {
  category                   = "Log Management"
  display_name               = "Count of IIS Log Entries by Host requested by client"
  log_analytics_workspace_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.OperationalInsights/workspaces/acctest-01"
  name                       = "LogManagement(acctest-01)_LogManagement|CountOfIISLogEntriesByHostRequestedByClient"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csHost\r\n// Oql: Type=W3CIISLog | Measure count() by csHost // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-44,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-60" {
  category                   = "Log Management"
  display_name               = "Count of IIS Log Entries by URL for the host \"www.contoso.com\" (replace with your own)"
  log_analytics_workspace_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.OperationalInsights/workspaces/acctest-01"
  name                       = "LogManagement(acctest-01)_LogManagement|CountOfIISLogEntriesByURLForHost"
  query                      = "search csHost == \"www.contoso.com\" | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csUriStem\r\n// Oql: Type=W3CIISLog csHost=\"www.contoso.com\" | Measure count() by csUriStem // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-44,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-61" {
  category                   = "Log Management"
  display_name               = "Count of IIS Log Entries by URL requested by client (without query strings)"
  log_analytics_workspace_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.OperationalInsights/workspaces/acctest-01"
  name                       = "LogManagement(acctest-01)_LogManagement|CountOfIISLogEntriesByURLRequestedByClient"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csUriStem\r\n// Oql: Type=W3CIISLog | Measure count() by csUriStem // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-44,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-62" {
  category                   = "Log Management"
  display_name               = "Count of Events with level \"Warning\" grouped by Event ID"
  log_analytics_workspace_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.OperationalInsights/workspaces/acctest-01"
  name                       = "LogManagement(acctest-01)_LogManagement|CountOfWarningEvents"
  query                      = "Event | where EventLevelName == \"warning\" | summarize AggregatedValue = count() by EventID\r\n// Oql: Type=Event EventLevelName=warning | Measure count() by EventID // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-44,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-63" {
  category                   = "Log Management"
  display_name               = "Shows breakdown of response codes"
  log_analytics_workspace_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.OperationalInsights/workspaces/acctest-01"
  name                       = "LogManagement(acctest-01)_LogManagement|DisplayBreakdownRespondCodes"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by scStatus\r\n// Oql: Type=W3CIISLog | Measure count() by scStatus // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-44,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-64" {
  category                   = "Log Management"
  display_name               = "Count of Events grouped by Event Log"
  log_analytics_workspace_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.OperationalInsights/workspaces/acctest-01"
  name                       = "LogManagement(acctest-01)_LogManagement|EventsByEventLog"
  query                      = "Event | summarize AggregatedValue = count() by EventLog\r\n// Oql: Type=Event | Measure count() by EventLog // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-44,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-65" {
  category                   = "Log Management"
  display_name               = "Count of Events grouped by Event Source"
  log_analytics_workspace_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.OperationalInsights/workspaces/acctest-01"
  name                       = "LogManagement(acctest-01)_LogManagement|EventsByEventSource"
  query                      = "Event | summarize AggregatedValue = count() by Source\r\n// Oql: Type=Event | Measure count() by Source // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-44,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-66" {
  category                   = "Log Management"
  display_name               = "Count of Events grouped by Event ID"
  log_analytics_workspace_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.OperationalInsights/workspaces/acctest-01"
  name                       = "LogManagement(acctest-01)_LogManagement|EventsByEventsID"
  query                      = "Event | summarize AggregatedValue = count() by EventID\r\n// Oql: Type=Event | Measure count() by EventID // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-44,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-67" {
  category                   = "Log Management"
  display_name               = "Events in the Operations Manager Event Log whose Event ID is in the range between 2000 and 3000"
  log_analytics_workspace_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.OperationalInsights/workspaces/acctest-01"
  name                       = "LogManagement(acctest-01)_LogManagement|EventsInOMBetween2000to3000"
  query                      = "Event | where EventLog == \"Operations Manager\" and EventID >= 2000 and EventID <= 3000 | sort by TimeGenerated desc\r\n// Oql: Type=Event EventLog=\"Operations Manager\" EventID:[2000..3000] // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-44,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-68" {
  category                   = "Log Management"
  display_name               = "Count of Events containing the word \"started\" grouped by EventID"
  log_analytics_workspace_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.OperationalInsights/workspaces/acctest-01"
  name                       = "LogManagement(acctest-01)_LogManagement|EventsWithStartedinEventID"
  query                      = "search in (Event) \"started\" | summarize AggregatedValue = count() by EventID\r\n// Oql: Type=Event \"started\" | Measure count() by EventID // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-44,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-69" {
  category                   = "Log Management"
  display_name               = "Find the maximum time taken for each page"
  log_analytics_workspace_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.OperationalInsights/workspaces/acctest-01"
  name                       = "LogManagement(acctest-01)_LogManagement|FindMaximumTimeTakenForEachPage"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = max(TimeTaken) by csUriStem\r\n// Oql: Type=W3CIISLog | Measure Max(TimeTaken) by csUriStem // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-44,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-70" {
  category                   = "Log Management"
  display_name               = "IIS Log Entries for a specific client IP Address (replace with your own)"
  log_analytics_workspace_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.OperationalInsights/workspaces/acctest-01"
  name                       = "LogManagement(acctest-01)_LogManagement|IISLogEntriesForClientIP"
  query                      = "search cIP == \"192.168.0.1\" | extend Type = $table | where Type == W3CIISLog | sort by TimeGenerated desc | project csUriStem, scBytes, csBytes, TimeTaken, scStatus\r\n// Oql: Type=W3CIISLog cIP=\"192.168.0.1\" | Select csUriStem,scBytes,csBytes,TimeTaken,scStatus // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-44,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-71" {
  category                   = "Log Management"
  display_name               = "All IIS Log Entries"
  log_analytics_workspace_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.OperationalInsights/workspaces/acctest-01"
  name                       = "LogManagement(acctest-01)_LogManagement|ListAllIISLogEntries"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | sort by TimeGenerated desc\r\n// Oql: Type=W3CIISLog // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-44,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-72" {
  category                   = "Log Management"
  display_name               = "How many connections to Operations Manager's SDK service by day"
  log_analytics_workspace_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.OperationalInsights/workspaces/acctest-01"
  name                       = "LogManagement(acctest-01)_LogManagement|NoOfConnectionsToOMSDKService"
  query                      = "Event | where EventID == 26328 and EventLog == \"Operations Manager\" | summarize AggregatedValue = count() by bin(TimeGenerated, 1d) | sort by TimeGenerated desc\r\n// Oql: Type=Event EventID=26328 EventLog=\"Operations Manager\" | Measure count() interval 1DAY // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-44,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-73" {
  category                   = "Log Management"
  display_name               = "When did my servers initiate restart?"
  log_analytics_workspace_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.OperationalInsights/workspaces/acctest-01"
  name                       = "LogManagement(acctest-01)_LogManagement|ServerRestartTime"
  query                      = "search in (Event) \"shutdown\" and EventLog == \"System\" and Source == \"User32\" and EventID == 1074 | sort by TimeGenerated desc | project TimeGenerated, Computer\r\n// Oql: shutdown Type=Event EventLog=System Source=User32 EventID=1074 | Select TimeGenerated,Computer // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-44,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-74" {
  category                   = "Log Management"
  display_name               = "Shows which pages people are getting a 404 for"
  log_analytics_workspace_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.OperationalInsights/workspaces/acctest-01"
  name                       = "LogManagement(acctest-01)_LogManagement|Show404PagesList"
  query                      = "search scStatus == 404 | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by csUriStem\r\n// Oql: Type=W3CIISLog scStatus=404 | Measure count() by csUriStem // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-44,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-75" {
  category                   = "Log Management"
  display_name               = "Shows servers that are throwing internal server error"
  log_analytics_workspace_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.OperationalInsights/workspaces/acctest-01"
  name                       = "LogManagement(acctest-01)_LogManagement|ShowServersThrowingInternalServerError"
  query                      = "search scStatus == 500 | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = count() by sComputerName\r\n// Oql: Type=W3CIISLog scStatus=500 | Measure count() by sComputerName // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-44,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-76" {
  category                   = "Log Management"
  display_name               = "Total Bytes received by each Azure Role Instance"
  log_analytics_workspace_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.OperationalInsights/workspaces/acctest-01"
  name                       = "LogManagement(acctest-01)_LogManagement|TotalBytesReceivedByEachAzureRoleInstance"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = sum(csBytes) by RoleInstance\r\n// Oql: Type=W3CIISLog | Measure Sum(csBytes) by RoleInstance // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-44,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-77" {
  category                   = "Log Management"
  display_name               = "Total Bytes received by each IIS Computer"
  log_analytics_workspace_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.OperationalInsights/workspaces/acctest-01"
  name                       = "LogManagement(acctest-01)_LogManagement|TotalBytesReceivedByEachIISComputer"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = sum(csBytes) by Computer | limit 500000\r\n// Oql: Type=W3CIISLog | Measure Sum(csBytes) by Computer | top 500000 // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-44,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-78" {
  category                   = "Log Management"
  display_name               = "Total Bytes responded back to clients by Client IP Address"
  log_analytics_workspace_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.OperationalInsights/workspaces/acctest-01"
  name                       = "LogManagement(acctest-01)_LogManagement|TotalBytesRespondedToClientsByClientIPAddress"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = sum(scBytes) by cIP\r\n// Oql: Type=W3CIISLog | Measure Sum(scBytes) by cIP // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-44,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-79" {
  category                   = "Log Management"
  display_name               = "Total Bytes responded back to clients by each IIS ServerIP Address"
  log_analytics_workspace_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.OperationalInsights/workspaces/acctest-01"
  name                       = "LogManagement(acctest-01)_LogManagement|TotalBytesRespondedToClientsByEachIISServerIPAddress"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = sum(scBytes) by sIP\r\n// Oql: Type=W3CIISLog | Measure Sum(scBytes) by sIP // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-44,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-80" {
  category                   = "Log Management"
  display_name               = "Total Bytes sent by Client IP Address"
  log_analytics_workspace_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.OperationalInsights/workspaces/acctest-01"
  name                       = "LogManagement(acctest-01)_LogManagement|TotalBytesSentByClientIPAddress"
  query                      = "search * | extend Type = $table | where Type == W3CIISLog | summarize AggregatedValue = sum(csBytes) by cIP\r\n// Oql: Type=W3CIISLog | Measure Sum(csBytes) by cIP // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PEF: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-44,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-81" {
  category                   = "Log Management"
  display_name               = "All Events with level \"Warning\""
  log_analytics_workspace_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.OperationalInsights/workspaces/acctest-01"
  name                       = "LogManagement(acctest-01)_LogManagement|WarningEvents"
  query                      = "Event | where EventLevelName == \"warning\" | sort by TimeGenerated desc\r\n// Oql: Type=Event EventLevelName=warning // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-44,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-82" {
  category                   = "Log Management"
  display_name               = "Windows Firewall Policy settings have changed"
  log_analytics_workspace_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.OperationalInsights/workspaces/acctest-01"
  name                       = "LogManagement(acctest-01)_LogManagement|WindowsFireawallPolicySettingsChanged"
  query                      = "Event | where EventLog == \"Microsoft-Windows-Windows Firewall With Advanced Security/Firewall\" and EventID == 2008 | sort by TimeGenerated desc\r\n// Oql: Type=Event EventLog=\"Microsoft-Windows-Windows Firewall With Advanced Security/Firewall\" EventID=2008 // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-44,
  ]
}
resource "azurerm_log_analytics_saved_search" "res-83" {
  category                   = "Log Management"
  display_name               = "On which machines and how many times have Windows Firewall Policy settings changed"
  log_analytics_workspace_id = "/subscriptions/5776697f-f76a-4a4a-9b42-ce2dbe5d7475/resourceGroups/featbit-tio-rg/providers/Microsoft.OperationalInsights/workspaces/acctest-01"
  name                       = "LogManagement(acctest-01)_LogManagement|WindowsFireawallPolicySettingsChangedByMachines"
  query                      = "Event | where EventLog == \"Microsoft-Windows-Windows Firewall With Advanced Security/Firewall\" and EventID == 2008 | summarize AggregatedValue = count() by Computer | limit 500000\r\n// Oql: Type=Event EventLog=\"Microsoft-Windows-Windows Firewall With Advanced Security/Firewall\" EventID=2008 | measure count() by Computer | top 500000 // Args: {OQ: True; WorkspaceId: 00000000-0000-0000-0000-000000000000} // Settings: {PTT: True; SortI: True; SortF: True} // Version: 0.1.122"
  depends_on = [
    azurerm_log_analytics_workspace.res-44,
  ]
}
