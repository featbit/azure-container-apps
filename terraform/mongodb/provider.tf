# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.71.0, < 4.0"
    }
    azapi = {
      source = "Azure/azapi"
      version = ">= 1.9.0, < 2.0"
    }
  }
}