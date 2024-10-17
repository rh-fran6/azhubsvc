terraform {
  required_providers {
    azuread = {
      source = "hashicorp/azuread"
    }
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}


provider "azurerm" {
  subscription_id = "18abddda-12e6-42e6-95f2-eef38ba20750"
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
