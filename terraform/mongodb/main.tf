# resource "azurerm_cosmosdb_account" "featbit" {
#   name                = var.cosmos_account_name
#   location            = var.location
#   resource_group_name = var.resource_group_name
#   offer_type          = "Standard"
#   kind                = "MongoDB"

#   enable_automatic_failover = true
#   # enable_free_tier = true
#   mongo_server_version          = 4.2
#   # public_network_access_enabled = true

#   capabilities {
#     name = "EnableAggregationPipeline"
#   }

#   capabilities {
#     name = "mongoEnableDocLevelTTL"
#   }

#   # capabilities {
#   #   name = "MongoDBv3.4"
#   # }

#   capabilities {
#     name = "EnableMongo"
#   }

#   consistency_policy {
#     consistency_level       = "BoundedStaleness"
#     max_interval_in_seconds = 300
#     max_staleness_prefix    = 100000
#   }

#   # geo_location {
#   #   location          = "eastus"
#   #   failover_priority = 1
#   # }

#   geo_location {
#     location          = "westeurope"
#     failover_priority = 0
#   }

#   # https://learn.microsoft.com/en-us/azure/cosmos-db/how-to-configure-firewall#allow-requests-from-the-azure-portal
#   # ip_range_filter = "104.42.195.92,40.76.54.131,52.176.6.30,52.169.50.45,52.187.184.26"
# }

# resource "azurerm_cosmosdb_mongo_database" "featbit" {
#   name                = "featbit"
#   resource_group_name = var.resource_group_name
#   account_name        = azurerm_cosmosdb_account.featbit.name

#   autoscale_settings {
#     max_throughput = var.db_max_throughput
#   }
# }

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}



resource "azurerm_private_dns_zone" "pdz" {
  name                = "privatelink.mongo.cosmos.azure.com"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnetlink_private" {
  name                  = "cosmosformongdbdnslink"
  private_dns_zone_name = azurerm_private_dns_zone.pdz.name
  resource_group_name   = azurerm_private_dns_zone.pdz.resource_group_name
  virtual_network_id    = var.vnet_id
  registration_enabled  = false
}

module "azure_cosmos_db" {
  source              = "Azure/cosmosdb/azurerm"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  cosmos_account_name = var.cosmos_account_name
  cosmos_api          = "mongo"
  mongo_dbs = {
    one = {
      db_name           = "featbit"
      db_throughput     = null
      db_max_throughput = 1000
    }
  }
  private_endpoint = {
    "pe_endpoint" = {
      dns_zone_group_name             = "pe_zone_group"
      dns_zone_rg_name                = azurerm_private_dns_zone.pdz.resource_group_name
      enable_private_dns_entry        = true
      is_manual_connection            = false
      name                            = "featbit-mongodb-pe"
      private_service_connection_name = "featbitCosmosDbPrivateServiceConnection"
      subnet_name                     = var.subnet_mongo_name
      vnet_name                       = var.vnet_name
      vnet_rg_name                    = data.azurerm_resource_group.rg.name
    }
  }
}

data "azapi_resource_action" "cosmosdb_featbit_connection_strings" {
  resource_id = module.azure_cosmos_db.cosmosdb_id
  type        = "Microsoft.DocumentDB/databaseAccounts@2021-10-15"
  action      = "listConnectionStrings"

  response_export_values = ["*"]

  depends_on = [module.azure_cosmos_db]
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





