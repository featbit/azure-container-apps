variable "resource_group_name" {
  default = "test-rg"
}

variable "location" {
  default = "westeurope"
}

variable "redis" {
  type = object({
    primary_access_key        = string
    hostname                  = string
    ssl_port                  = string
    primary_connection_string = string
  })
}

variable "container_apps_environment" {
  default = "featbit-environment"
}

variable "subnet_aca_id" {
  type = string
}

variable "mongodb_connection_str" {
  type = string
}

variable "mongodb_dbname" {
  default = "featbit"
}

variable "mongodb_primary_key" {
  type = string
}

variable "mongodb_primary_sql_connection_string" {
  type = string
}

variable "container_name" {
  type = object({
    ui          = string
    api_server  = string
    eval_server = string
    da_server   = string
  })
  default = {
    ui          = "ui"
    api_server  = "api-server"
    eval_server = "evaluation-server"
    da_server   = "da-server"
  }
}
