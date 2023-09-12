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
    connection_str = ""
    db_name        = "featbit"
  }
}

variable "redis" {
  type = object({
    capacity                      = number
    family                        = string
    sku_name                      = string
    enable_non_ssl_port           = bool
    minimum_tls_version           = string
    public_network_access_enabled = bool
  })
  default = {
    capacity            = 0
    family              = "C"
    sku_name            = "Standard"
    enable_non_ssl_port = false
    minimum_tls_version = "1.2"
    public_network_access_enabled = true
  }
}
