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
    api  = string
    eval = string
    da   = string
  })
  default = {
    ui   = "ui"
    api  = "api-server"
    eval = "evaluation-server"
    da   = "da-server"
  }
}
