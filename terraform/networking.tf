/*
# --- Networking for Bonus Challenge ---
# (Intentionally commented out as standard Y1 Consumption does not support Private Endpoints.
#  This infrastructure is theoretically valid for EP1 or Flex Consumption tiers.)

resource "azurerm_virtual_network" "vnet" {
  name                = "${var.project_name}-${var.environment}-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
  tags                = var.tags
}

resource "azurerm_subnet" "pe_subnet" {
  name                 = "private-endpoints"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_private_dns_zone" "dns" {
  name                = "privatelink.azurewebsites.net"
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "vnet_link" {
  name                  = "${var.project_name}-vnet-link"
  resource_group_name   = azurerm_resource_group.rg.name
  private_dns_zone_name = azurerm_private_dns_zone.dns.name
  virtual_network_id    = azurerm_virtual_network.vnet.id
  tags                  = var.tags
}

# --- Bonus Challenge Private Endpoint Attached to Data Plane ---
resource "azurerm_private_endpoint" "pe" {
  name                = "${var.project_name}-pe"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.pe_subnet.id
  tags                = var.tags

  private_dns_zone_group {
    name                 = "function-dns-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.dns.id]
  }

  private_service_connection {
    name                           = "function-privatelink"
    private_connection_resource_id = azurerm_windows_function_app.function.id
    subresource_names              = ["sites"]
    is_manual_connection           = false
  }
}
*/
