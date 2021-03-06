// Create Service Principals

// Create Azure Resource Group
resource "random_id" "phxvlabs-rg-name" {
  byte_length = 5
  prefix      = var.resource_group_name_prefix

}
resource "azurerm_resource_group" "phxvlabs-rg" {
  name     = random_id.phxvlabs-rg-name.hex
  location = var.location
  tags = {
    "Environment" = "dev"
  }
}

// Create Azure Key Vault to store cosign public key
data "azurerm_client_config" "current" {}

resource "random_id" "phxvlabs-kv-name" {
  byte_length = 5
  prefix      = "key-vault-"
}

resource "azurerm_key_vault" "phxvlabs-cosign-kv1" {
  depends_on          = [azurerm_resource_group.phxvlabs-rg]
  name                = random_id.phxvlabs-kv-name.hex
  location            = var.location
  resource_group_name = azurerm_resource_group.phxvlabs-rg.name
  sku_name            = var.sku_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
}

// Create Azure Container Registry
resource "azurerm_container_registry" "phxvlabs-dev-acr" {
  name                = "phxvlabsdevacr"
  resource_group_name = azurerm_resource_group.phxvlabs-rg.name
  location            = azurerm_resource_group.phxvlabs-rg.location
  sku                 = "Basic"
  admin_enabled       = "false"
  tags = {
    "Environment" = "dev"
  }
}