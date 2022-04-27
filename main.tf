
#resource "azurerm_site_recovery_protection_container" "primary" {
#  name                 = "asr-a2a-default-uksouth-container_new"
#  resource_group_name  = data.azurerm_recovery_services_vault.vault.resource_group_name
#  recovery_vault_name  = data.azurerm_recovery_services_vault.vault.name
#  recovery_fabric_name = data.azurerm_site_recovery_fabric.primary.name
#}

#resource "azurerm_site_recovery_protection_container" "secondary" {
#  name                 = "asr-a2a-default-ukwest-container-new"
#  resource_group_name  = data.azurerm_recovery_services_vault.vault.resource_group_name
#  recovery_vault_name  = data.azurerm_recovery_services_vault.vault.name
#  recovery_fabric_name = data.azurerm_site_recovery_fabric.secondary.name
#}

#resource "azurerm_site_recovery_protection_container_mapping" "container-mapping" {
#  name                                      = "container-mapping-new"
#  resource_group_name                       = data.azurerm_resource_group.secondary.name
#  recovery_vault_name                       = data.azurerm_recovery_services_vault.vault.name
#  recovery_fabric_name                      = data.azurerm_site_recovery_fabric.primary.name
#  recovery_source_protection_container_name = azurerm_site_recovery_protection_container.primary.name
#  recovery_target_protection_container_id   = azurerm_site_recovery_protection_container.secondary.id
#  recovery_replication_policy_id            = data.azurerm_site_recovery_replication_policy.policy.id
#}

#resource "azurerm_site_recovery_network_mapping" "network-mapping" {
#  name                        = "network-mapping-new"
#  resource_group_name         = data.azurerm_resource_group.secondary.name
#  recovery_vault_name         = data.azurerm_recovery_services_vault.vault.name
#  source_recovery_fabric_name = data.azurerm_site_recovery_fabric.primary.name
#  target_recovery_fabric_name = data.azurerm_site_recovery_fabric.secondary.name
#  source_network_id           = data.azurerm_virtual_network.primary.id
#  target_network_id           = data.azurerm_virtual_network.secondary.id
#}

resource "azurerm_site_recovery_replicated_vm" "vm-replication" {
  name                                      = format("%s-vmrep", var.vm_name)
  resource_group_name                       = data.azurerm_resource_group.secondary.name
  recovery_vault_name                       = data.azurerm_recovery_services_vault.vault.name
  source_recovery_fabric_name               = data.azurerm_site_recovery_fabric.primary.name
  source_vm_id                              = data.azurerm_virtual_machine.vm.id
  recovery_replication_policy_id            = data.azurerm_site_recovery_replication_policy.policy.id
  source_recovery_protection_container_name = data.azurerm_site_recovery_protection_container.primary.name

  target_resource_group_id                = data.azurerm_resource_group.secondary.id
  target_recovery_fabric_id               = data.azurerm_site_recovery_fabric.secondary.id
  target_recovery_protection_container_id = data.azurerm_site_recovery_protection_container.secondary.id

  managed_disk {
    disk_id                    = data.azurerm_managed_disk.osdisk.id
    staging_storage_account_id = data.azurerm_storage_account.primary.id
    target_resource_group_id   = data.azurerm_resource_group.secondary.id
    target_disk_type           = "Premium_LRS"
    target_replica_disk_type   = "Premium_LRS"
  }

  network_interface {
    source_network_interface_id   = data.azurerm_network_interface.vm.id
    target_subnet_name            = data.azurerm_subnet.secondary.name
  }

#  depends_on = [
#    azurerm_site_recovery_protection_container_mapping.container-mapping,
#    azurerm_site_recovery_network_mapping.network-mapping,
#  ]
}
