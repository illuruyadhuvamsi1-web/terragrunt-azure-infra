resource "azurerm_storage_account" "stg" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = var.account_replication_type
  lifecycle {
    precondition {
    condition     = var.account_replication_type == "LRS"
    error_message = "Policy violation: Storage Account replication type must be LRS."
  }
  }
  
}

