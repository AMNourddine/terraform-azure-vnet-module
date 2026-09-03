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
    }
  }

  tags = {
    Environment = "test"
    Project     = "terraform-azure-vnet-module"
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

