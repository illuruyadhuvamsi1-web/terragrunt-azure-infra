include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

dependency "rg" {
  config_path = "../rg"
  mock_outputs = {
    name = "mock-rg-name"
  }
}

terraform {
  source = "../../../modules/key-vault"
}

inputs = {
  name                = "${local.env.locals.kv_prefix}-app2-${local.env.locals.env_name}-kf2"
  location            = local.env.locals.location
  resource_group_name = dependency.rg.outputs.name
  tenant_id           = "196eed21-c67a-4aae-a70b-9f97644d5d14"
}