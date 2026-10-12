# terraform-azure-vnet-module

A small Terraform module that creates an Azure virtual network with a set of subnets, and optionally attaches a network security group (NSG) to each subnet.

I wrote it as a reusable building block for Azure landing zones, so the network layer is defined once and reused across environments.

## What it creates

- One virtual network
- Any number of subnets, defined in a single map
- An NSG association for each subnet that has an `nsg_id`

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azurerm | ~> 5.0 |

## Usage

```hcl
module "vnet" {
  source = "github.com/AMNOURDDINE/terraform-azure-vnet-module"

  resource_group_name = "rg-network-dev"
  location            = "westeurope"
  vnet_name           = "vnet-dev"
  address_space       = ["10.10.0.0/16"]

  subnets = {
    app = {
      address_prefixes = ["10.10.1.0/24"]
      nsg_id           = azurerm_network_security_group.app.id
    }
    data = {
      address_prefixes = ["10.10.2.0/24"]
    }
  }

  tags = {
    environment = "dev"
  }
}
```

A complete working example is in [`examples/basic`](examples/basic).

## Inputs

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `resource_group_name` | Resource group where the resources are created | `string` | n/a |
| `location` | Azure region | `string` | n/a |
| `vnet_name` | Name of the virtual network | `string` | n/a |
| `address_space` | Address space of the virtual network | `list(string)` | n/a |
| `subnets` | Map of subnets. The key is the subnet name, the value holds `address_prefixes` and an optional `nsg_id` | `map(object)` | `{}` |
| `tags` | Tags applied to the resources | `map(string)` | `{}` |

## Outputs

| Name | Description |
|------|-------------|
| `vnet_id` | ID of the virtual network |
| `vnet_name` | Name of the virtual network |
| `subnet_ids` | Map of subnet names to subnet IDs |

## Quality checks

A GitHub Actions workflow runs on every push:

- `terraform init` and `terraform validate`
- `tflint`
- `checkov` (security scan)

One Checkov rule (CKV2_AZURE_31) is skipped on purpose. The NSG association is implemented through a separate resource with a filtered `for_each`, and Checkov cannot follow that pattern. The reason is documented in `main.tf`, and the setup was checked with a real `terraform apply` using the example.
