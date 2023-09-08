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

variable "mongodb" {
  type = object({
    connection_str = string
    db_name        = string
  })
  default = {
    connection_str = "mongodb://admin:password@mongodb:27017"
    db_name        = "featbit"
  }
}

variable "redis" {
  type = object({
    if_has_redis = bool

    capacity            = number
    family              = string
    sku_name            = string
    enable_non_ssl_port = bool
    minimum_tls_version = string

    connection_str = string
  })
  default = {
    if_has_redis = true

    capacity            = 0
    family              = "C"
    sku_name            = "Basic"
    enable_non_ssl_port = false
    minimum_tls_version = "1.2"

    connection_str = "http://redis:6379"
  }
}
