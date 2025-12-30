locals {
  env_name        = "prod"
  location        = "north europe"
  subscription_id = "270ea0f5-3ed6-4fd0-854e-f0573a3ff64c"

  # Naming prefixes
  rg_prefix       = "rg"
  kv_prefix       = "kv"
  app_prefix      = "appsvc"

  # Tags
  tags = {
    Environment = local.env_name
    Project     = "MyProjectApp2"
    Owner       = "DevOpsTeam"
  }
}