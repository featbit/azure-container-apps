variable "resource_group_name" {
  default = "featbit-tio-rg"
}

variable "location" {
  default = "westeurope"
}

variable "container_apps_environment" {
  default = "featbit-environment"
}

variable "container_name" {
  type = object({
    ui   = string
    api_server  = string
    eval_server = string
    da_server   = string
  })
  default = {
    ui   = "ui"
    api_server  = "api-server"
    eval_server = "evaluation-server"
    da_server   = "da-server"
  }
}

variable "mongodb" {
  type = object({
    connection_str   = string
    db_name  = string
  })
  default = {
    connection_str   = "mongodb://admin:password@mongodb:27017"
    db_name  = "featbit"
  }
}

variable "redis" {
  type = object({
    connection_str   = string
  })
  default = {
    connection_str   = "http://redis:6379"
  }
}