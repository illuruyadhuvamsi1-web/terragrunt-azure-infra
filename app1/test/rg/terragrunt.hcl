include "root" {
  path = find_in_parent_folders("root.hcl")
}


locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "../../../modules/resource-group"
}

inputs = {
  name     = "${local.env.locals.rg_prefix}-app1-${local.env.locals.env_name}"
  location = local.env.locals.location
  tags     = local.env.locals.tags
}
