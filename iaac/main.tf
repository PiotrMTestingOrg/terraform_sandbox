data "azurerm_client_config" "current" {}

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

resource "azurerm_storage_account" "adls" {
  name                     = "adlstf${var.environment}projectpm"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  is_hns_enabled = true
}

resource "azurerm_storage_container" "base_container" {
  name                  = "test-data"
  storage_account_name  = azurerm_storage_account.adls.name
  container_access_type = "private"
}

resource "azurerm_cognitive_account" "openai" {
  custom_subdomain_name = "openai-projectpm-${var.environment}"
  kind                  = "OpenAI"
  location              = azurerm_resource_group.rg.location
  name                  = "openai-projectpm-${var.environment}"
  resource_group_name   = azurerm_resource_group.rg.name
  sku_name              = "S0"
}

resource "azurerm_key_vault" "kv" {
  name                        = "kv-projectpm-${var.environment}"
  location                    = azurerm_resource_group.rg.location
  resource_group_name         = azurerm_resource_group.rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"
  enable_rbac_authorization = true

}