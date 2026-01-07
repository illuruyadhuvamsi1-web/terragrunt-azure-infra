locals {
  env_name        = "dev"
  location        = "eastus"
  subscription_id = "270ea0f5-3ed6-4fd0-854e-f0573a3ff64c"

 # Naming prefixes
  rg_prefix       = "rg"
  stg_prefix      = "st"
  vnet_prefix     = "vnet"
  subnet_prefix   = "subnet"
  app_prefix      = "app"

  # Tags
  tags = {
    Environment = local.env_name
    Project     = "MyProject"
    Owner       = "DevOpsTeam"
  }

  # Networking
  vnet_name    = "${local.vnet_prefix}-app1-${local.env_name}-$#"
  subnet_name     = "${local.subnet_prefix}-${local.env_name}"
  address_space   = ["10.0.0.0/16"]
  subnet_prefixes = ["10.0.1.0/24", "10.0.2.0/24"]

  # Storage default SKU
  storage_sku = "Standard_LRS"
}
