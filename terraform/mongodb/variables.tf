variable "resource_group_name" {
  default = "test-rg"
}

variable "location" {
  default = "westeurope"
}

variable "cosmos_account_name"{
  default = "featbit-mongodb"
}

variable "db_defaiult_throughput" {
  default = 400
}

variable "db_max_throughput" {
  default = 1000
}

variable "vnet_id" {
  type = string
}

variable vnet_name {
  type = string
}

variable "pe_name"{
  default = "cosmosdb_pe"
}

variable pe_connection_name{
  default = "cosmosdb_pe_connection"
} 

variable "subnet_mongo_name" {
  type = string
}

variable "private_dns_vnet_link_name"{
  default = "cosmosformongodb_zone_link"
}

variable "dns_zone_group_name"{
  default = "pe_zone_group"
}

variable "subnet_mongodb_id"{
  type = string
}