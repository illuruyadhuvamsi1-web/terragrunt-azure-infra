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
  source = "../../../modules/app-service"
}

inputs = {
  plan_name           = "${local.env.locals.app_prefix}-plan-${local.env.locals.env_name}"
  app_name            = "${local.env.locals.app_prefix}-app-${local.env.locals.env_name}"
  location            = local.env.locals.location
  resource_group_name = dependency.rg.outputs.name
}
