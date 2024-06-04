terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.34.0"
    }
  }
  # required_version = "~> 1.3.6"
  backend "azurerm" {
    resource_group_name  = "rg-naharneha96"
    storage_account_name = "sastoredata01"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = "rg-naharneha96" # change to your rg name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.prefix}-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.vnetAdressSpace
}

resource "azurerm_subnet" "subnet" {
  for_each             = var.subnets
  name                 = each.value.name
  address_prefixes     = [each.value.address]
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}