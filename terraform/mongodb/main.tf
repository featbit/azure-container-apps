resource "azurerm_cosmosdb_account" "featbit" {
  name                = var.cosmos_account_name
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = "Standard"
  kind                = "MongoDB"

  enable_automatic_failover = true
  # enable_free_tier = true
  mongo_server_version          = 4.2
  # public_network_access_enabled = true

  capabilities {
    name = "EnableAggregationPipeline"
  }

  capabilities {
    name = "mongoEnableDocLevelTTL"
  }

  # capabilities {
  #   name = "MongoDBv3.4"
  # }

  capabilities {
    name = "EnableMongo"
  }

  consistency_policy {
    consistency_level       = "BoundedStaleness"
    max_interval_in_seconds = 300
    max_staleness_prefix    = 100000
  }

  # geo_location {
  #   location          = "eastus"
  #   failover_priority = 1
  # }

  geo_location {
    location          = "westeurope"
    failover_priority = 0
  }

  # https://learn.microsoft.com/en-us/azure/cosmos-db/how-to-configure-firewall#allow-requests-from-the-azure-portal
  # ip_range_filter = "104.42.195.92,40.76.54.131,52.176.6.30,52.169.50.45,52.187.184.26"
}

resource "azurerm_cosmosdb_mongo_database" "featbit" {
  name                = "featbit"
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.featbit.name

  autoscale_settings {
    max_throughput = var.db_max_throughput
  }
}

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azapi_resource_action" "cosmosdb_featbit_connection_strings" {
  resource_id = azurerm_cosmosdb_account.featbit.id
  type = "Microsoft.DocumentDB/databaseAccounts@2021-10-15"
  action = "listConnectionStrings"

  response_export_values = ["*"]

  depends_on = [azurerm_cosmosdb_mongo_database.featbit]
}

resource "azurerm_private_dns_zone" "pdz" {
  name                = "privatelink.mongo.cosmos.azure.com"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_endpoint" "featbit_comosdb_pe" {
  name                          = "featbit-mongodb-pe"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  subnet_id                     = var.subnet_mongodb_id

  private_service_connection {
    name                           = "featbitCosmosDbPrivateServiceConnection"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_cosmosdb_account.featbit.id
    subresource_names              = ["MongoDB"]
  }
}

locals {
  mongo_server = [
    for c in azurerm_private_endpoint.featbit_comosdb_pe.custom_dns_configs : c.ip_addresses[0]
    if c.fqdn == "${azurerm_cosmosdb_account.featbit.name}.mongo.cosmos.azure.com"
  ][0]
}

resource "azurerm_private_dns_a_record" "comosdb" {
  name                = azurerm_cosmosdb_account.featbit.name
  records             = [local.mongo_server]
  resource_group_name = azurerm_cosmosdb_account.featbit.resource_group_name
  ttl                 = 3600
  zone_name           = azurerm_private_dns_zone.pdz.name
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnetlink_private" {
  name                  = "cosmosformongdbdnslink"
  private_dns_zone_name = azurerm_private_dns_zone.pdz.name
  resource_group_name   = azurerm_private_dns_zone.pdz.resource_group_name
  virtual_network_id    = var.vnet_id
}

# resource "azurerm_cosmosdb_mongo_collection" "collection_inituser" {
#   for_each            = toset(["Users", "Organizations", "OrganizationUsers", "Administrator", "Developer", "MemberPolicies"])
#   name                = each.key
#   resource_group_name = azurerm_cosmosdb_account.featbit.resource_group_name
#   account_name        = azurerm_cosmosdb_account.featbit.name
#   database_name       = azurerm_cosmosdb_mongo_database.featbit.name

#   autoscale_settings {
#     max_throughput = var.db_max_throughput
#   }

#   index {
#     keys   = ["_id"]
#     unique = true
#   }
# }


# resource "azurerm_cosmosdb_mongo_collection" "collection_createdat_index" {
#   for_each            = toset(["RelayProxies", "Projects", "AccessTokens", "Policies", "AuditLogs"])
#   name                = each.key
#   resource_group_name = azurerm_cosmosdb_account.featbit.resource_group_name
#   account_name        = azurerm_cosmosdb_account.featbit.name
#   database_name       = azurerm_cosmosdb_mongo_database.featbit.name

#   autoscale_settings {
#     max_throughput = var.db_max_throughput
#   }

#   index {
#     keys   = ["_id"]
#     unique = true
#   }

#   index {
#     keys   = ["createdAt"]
#     unique = true
#   }
# }

# resource "azurerm_cosmosdb_mongo_collection" "collection_updatedat_index" {
#   for_each            = toset(["EndUsers", "FeatureFlags", "Segments"])
#   name                = each.key
#   resource_group_name = azurerm_cosmosdb_account.featbit.resource_group_name
#   account_name        = azurerm_cosmosdb_account.featbit.name
#   database_name       = azurerm_cosmosdb_mongo_database.featbit.name

#   autoscale_settings {
#     max_throughput = var.db_max_throughput
#   }

#   index {
#     keys   = ["_id"]
#     unique = true
#   }

#   index {
#     keys   = ["updatedAt"]
#     unique = true
#   }
# }

# resource "azurerm_cosmosdb_mongo_collection" "collection_Events" {
#   name                = "Events"
#   resource_group_name = azurerm_cosmosdb_account.featbit.resource_group_name
#   account_name        = azurerm_cosmosdb_account.featbit.name
#   database_name       = azurerm_cosmosdb_mongo_database.featbit.name

#   shard_key           = "_id"

#   autoscale_settings {
#     max_throughput = var.db_max_throughput
#   }

#   index {
#     keys   = ["_id"]
#     unique = true
#   }
# }





