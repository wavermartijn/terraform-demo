terraform {
  required_providers {
    azurerm = {
      # The "hashicorp" namespace is the new home for the HashiCorp-maintained
      # provider plugins.
      #
      # source is not required for the hashicorp/* namespace as a measure of
      # backward compatibility for commonly-used providers, but recommended for
      # explicitness.
      source  = "hashicorp/azurerm"
      version = "= 2.20"
    }
  }
//  backend "azurerm" {
//    resource_group_name   = "tstate"
//    storage_account_name  = "tstatemvdp"
//    container_name        = "tstate"
//    key                   = "terraform.tfstate"
//  }
}

provider "azurerm" {
  version = ">= 2.20.0"
  features {}
}


resource "azurerm_resource_group" "rockstars-rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_container_group" "containergroup" {
  name                  = var.container_group_name
  resource_group_name   = azurerm_resource_group.rockstars-rg.name
  location              = azurerm_resource_group.rockstars-rg.location
  ip_address_type       = "public"
  dns_name_label        = var.dns_name_label
  os_type               = var.os_type

  container {
    name = var.container_name
    image = var.image_name
    cpu = var.cpu_core_number
    memory = var.memory_size
    ports {
      port = var.port_number

    }
    environment_variables = {
      spring_profiles_active = var.environment
    }
  }


  tags = {
    Stack = "rockstars"
    DeployDate = timestamp()

  }
}


resource "azurerm_postgresql_server" "rockstars-postgres" {
  name                = "rockstars-postgres-${var.environment}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rockstars-rg.name

  administrator_login          = "psadmin"
  administrator_login_password = "bla!P@ass"

  sku_name   = "B_Gen5_1"
  version    = "11"
  storage_mb = 5120

  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  auto_grow_enabled            = false

  ssl_enforcement_enabled          = false

}

