
provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.0"
    }
  }
}

resource "azurerm_resource_group" "example" {
  name     = "rg-terraform-module-test"
  location = "eastus"
}

module "vnet" {
  source              = "../../"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  vnet_name            = "vnet-module-test"
  address_space         = ["10.0.0.0/16"]

  subnets = {
    "workload-subnet" = {
      address_prefixes = ["10.0.1.0/24"]
      nsg_id           = azurerm_network_security_group.example.id
    }
  }

  tags = {
    Environment = "test"
    Project     = "terraform-azure-vnet-module"
  }
}

resource "azurerm_network_security_group" "example" {
  name                = "nsg-terraform-module-test"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

    security_rule {
    name                       = "AllowVnetInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }
}

output "vnet_id" {
  value = module.vnet.vnet_id
}

output "vnet_name" {
  value = module.vnet.vnet_name
}

output "subnet_ids" {
  value = module.vnet.subnet_ids
}

