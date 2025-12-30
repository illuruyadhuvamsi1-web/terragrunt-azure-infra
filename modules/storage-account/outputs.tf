output "name" {
  description = "Storage Account name"
  value       = azurerm_storage_account.stg.name
}

output "id" {
  description = "Storage Account resource ID"
  value       = azurerm_storage_account.stg.id
}

output "primary_blob_endpoint" {
  description = "Primary Blob endpoint"
  value       = azurerm_storage_account.stg.primary_blob_endpoint
}