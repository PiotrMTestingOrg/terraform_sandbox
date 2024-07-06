resource "azurerm_resource_group" "rg" {
  name     = "rg-tf-${var.environment}"
  location = "West Europe"
}

resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-tf-${var.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-tf-${var.environment}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = "subnet-pe"
    address_prefix = "10.0.1.0/24"
    security_group = azurerm_network_security_group.nsg.id
  }
}

resource "azurerm_storage_account" "sa" {
  name                     = "satf${var.environment}projectpm"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
}