remote_state {
  backend = "azurerm"
  config = {
    resource_group_name  = "practice-rg"
    storage_account_name = "mystorage3cmjz5"
    container_name       = "blobcontainer"
    key                  = "${path_relative_to_include()}/terraform.tfstate"
  }
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "azurerm" {
  features {}
  subscription_id = "${local.env.locals.subscription_id}"
}
EOF
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}