terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tf-storage"
    storage_account_name = "satfdevproject"
    container_name       = "terraform"
    key                  = "dev/terraform.tfstate"
    use_azuread_auth     = true   
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }
}