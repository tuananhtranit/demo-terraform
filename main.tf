resource "azurerm_resource_group" "example" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_eventhub_namespace" "example" {
  name                = var.eventhub_namespace_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = var.sku
  capacity            = 1

  tags = var.tags
}

resource "azurerm_eventhub" "example" {
  name                = var.eventhub_name
  namespace_name      = azurerm_eventhub_namespace.example.name
  resource_group_name = azurerm_resource_group.example.name
  partition_count     = 2
  message_retention   = 1
}