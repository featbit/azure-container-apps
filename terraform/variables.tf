variable "resource_group_name" {
  default = "featbit-tio-rg"
}

variable "location" {
  default = "westeurope"
}

variable "redis" {
  type = object({
    capacity                      = optional(number, 0)
    family                        = optional(string, "C")
    sku_name                      = optional(string, "Basic")
    enable_non_ssl_port           = optional(bool, false)
    minimum_tls_version           = optional(string, "1.2")
    public_network_access_enabled = optional(bool, false)
  })
  default = {
    capacity            = 0
    family              = "C"
    sku_name            = "Basic"
    enable_non_ssl_port = false
    minimum_tls_version = "1.2"
    public_network_access_enabled = false
  }
}

variable "cosmos_account_name"{
  default = "featbit-mongodb"
}