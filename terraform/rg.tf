resource "azurerm_resource_group" "featbit" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Team = "FeatBit"
  }
}