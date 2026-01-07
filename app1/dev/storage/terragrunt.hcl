
include "root" {
  path = find_in_parent_folders("root.hcl")
}


locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "../../../modules/storage-account"
}

dependency "rg" {
  config_path = "../rg"
  mock_outputs = {
    name = "mock-rg-name"
  }
}

inputs = {
  name                = "st${local.env.locals.env_name}terrapractice12"
  resource_group_name = dependency.rg.outputs.name
  location            = local.env.locals.location
  account_tier        = local.env.locals.storage_sku
}
