# - Primary and Secondary resource Groups - #
data "azurerm_resource_group" "primary" {
  name     = var.primary_resource_group
}

data "azurerm_resource_group" "secondary" {
  name     = var.secondary_resource_group
}

# - Primary and Secondary virtual networks - #
data "azurerm_virtual_network" "primary" {
  name                = var.primary_network
  resource_group_name = var.network_resource_group
}

data "azurerm_virtual_network" "secondary" {
  name                = var.secondary_network
  resource_group_name = var.network_resource_group
}

# - Primary and Secondary Subnets - #
data "azurerm_subnet" "primary" {
  name                 = var.primary_subnet
  resource_group_name  = var.network_resource_group
  virtual_network_name = data.azurerm_virtual_network.primary.name
}

data "azurerm_subnet" "secondary" {
  name                 = var.secondary_subnet
  resource_group_name  = var.network_resource_group
  virtual_network_name = data.azurerm_virtual_network.secondary.name
}

# - Recovery services vault - #
data "azurerm_recovery_services_vault" "vault" {
  name                = var.recovery_services_vault
  resource_group_name = var.rsv_resource_group
}

# This is the Fabric in the source location
data "azurerm_site_recovery_fabric" "primary" {
  name                = "asr-a2a-default-uksouth"
  recovery_vault_name = data.azurerm_recovery_services_vault.vault.name
  resource_group_name = data.azurerm_recovery_services_vault.vault.resource_group_name
}

# This is the Fabric in the target location
data "azurerm_site_recovery_fabric" "secondary" {
  name                = "asr-a2a-default-ukwest"
  recovery_vault_name = data.azurerm_recovery_services_vault.vault.name
  resource_group_name = data.azurerm_recovery_services_vault.vault.resource_group_name
}

data "azurerm_site_recovery_protection_container" "primary" {
  name                 = "asr-a2a-default-uksouth-container"
  resource_group_name  = data.azurerm_recovery_services_vault.vault.resource_group_name
  recovery_vault_name  = data.azurerm_recovery_services_vault.vault.name
  recovery_fabric_name = data.azurerm_site_recovery_fabric.primary.name
}

data "azurerm_site_recovery_protection_container" "secondary" {
  name                 = "asr-a2a-default-ukwest-container"
  resource_group_name  = data.azurerm_recovery_services_vault.vault.resource_group_name
  recovery_vault_name  = data.azurerm_recovery_services_vault.vault.name
  recovery_fabric_name = data.azurerm_site_recovery_fabric.secondary.name
}

data "azurerm_site_recovery_replication_policy" "policy" {
  name                                                 = "asr-a2a-default-policy"
  resource_group_name                                  = data.azurerm_recovery_services_vault.vault.resource_group_name
  recovery_vault_name                                  = data.azurerm_recovery_services_vault.vault.name
}

# - Cache Storage Account - #
data "azurerm_storage_account" "primary" {
  name                     = var.primary_storage_account
  resource_group_name      = var.rsv_resource_group
}

# - Name of the VM being replicated - #
data "azurerm_virtual_machine" "vm" {
  name                = var.vm_name
  resource_group_name = data.azurerm_resource_group.primary.name
}

data "azurerm_network_interface" "vm" {
  name                = format("%s-nic1", var.vm_name)
  resource_group_name = data.azurerm_resource_group.primary.name
}

data "azurerm_managed_disk" "osdisk" {
  name                = format("%s-osdisk", var.vm_name)
  resource_group_name = data.azurerm_resource_group.primary.name
}
