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
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

module "resource_group" {
  source              = "./resource_group"
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "vnet" {
  source              = "./vnet"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
}

module "redis" {
  source              = "./redis"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  redis               = var.redis
  subnet_redis_id     = module.vnet.subnet_redis_id
  vnet_id             = module.vnet.vnet_id
}

module "cosmosdb_for_mongodb" {
  source              = "./mongodb"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  cosmos_account_name = var.cosmos_account_name
  vnet_id             = module.vnet.vnet_id
  subnet_mongo_name   = module.vnet.subnet_mongo_name
  subnet_mongodb_id   = module.vnet.subnet_mongodb_id
  vnet_name           = module.vnet.vnet_name
}

module "azure_container_apps" {
  source              = "./aca"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  redis = {
    primary_access_key        = module.redis.primary_access_key
    hostname                  = module.redis.hostname
    ssl_port                  = module.redis.ssl_port
    primary_connection_string = module.redis.primary_connection_string
  }
  mongodb_connection_str                = format("mongodb://%s:%s@%s.mongo.cosmos.azure.com:10255/?ssl=true&replicaSet=globaldb&retrywrites=false&maxIdleTimeMS=120000&appName=@%s@", 
                                                 var.cosmos_account_name, 
                                                 module.cosmosdb_for_mongodb.mongodb_primary_key, 
                                                 var.cosmos_account_name, 
                                                 var.cosmos_account_name)
  subnet_aca_id                         = module.vnet.subnet_aca_id
  mongodb_primary_sql_connection_string = module.cosmosdb_for_mongodb.mongodb_primary_sql_connection_string
  mongodb_primary_key                   = module.cosmosdb_for_mongodb.mongodb_primary_key
  depends_on = [
    module.cosmosdb_for_mongodb
  ]
  # mongodb_connection_str = "mongodb://featbit-cosmosdb-for-mongodb:Mmou0lLH7CrqPTAtuMjXUzXg4Skqa7koX0Ypj9fWrn8WVRNYxSWNRVi5DbsjLYvxMgfCvaTYdnagACDb2xXoow==@featbit-cosmosdb-for-mongodb.mongo.cosmos.azure.com:10255/?ssl=true&replicaSet=globaldb&retrywrites=false&maxIdleTimeMS=120000&appName=@featbit-cosmosdb-for-mongodb@"

}
