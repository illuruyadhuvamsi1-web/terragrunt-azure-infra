include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "../../../modules/networking"
}

dependency "rg" {
  config_path = "../rg"
  mock_outputs = {
    name = "mock-rg-name"
  }
}

inputs = {
  subnet_name         = local.env.locals.subnet_name
  address_space       = jsonencode(local.env.locals.address_space)
  subnet_prefixes     = jsonencode(local.env.locals.subnet_prefixes)
  resource_group_name = dependency.rg.outputs.name
  location            = local.env.locals.location
  tags                = jsonencode(local.env.locals.tags)
}
