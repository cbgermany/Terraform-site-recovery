# -------------------------------------------------------------------------- #
# Variables used by site-recovery module                                     
# -------------------------------------------------------------------------- #

variable "network_resource_group" {
  type        = string
  description = "The name of the resource group for the network resources"
}

variable "rsv_resource_group" {
  type        = string
  description = "The name of the resource group for the recovery services vault"
}


variable "primary_resource_group" {
  type        = string
  description = "The Azure resource group for the target VMs"
}

variable "primary_network" {
  type        = string
  description = "The name of the primary network for the VMs being replicated"
}

variable "primary_subnet" {
  type        = string
  description = "The name of the primary subnet where the VM resides"
}

variable "primary_storage_account" {
  type        = string
  description = "The name of the storage account where the storage cache resides"
}

variable "secondary_resource_group" {
  type        = string
  description = "The Azure resource group of the replicated VMs"
}

variable "secondary_network" {
  type        = string
  description = "The name of the secondary network in the target location"
}

variable "secondary_subnet" {
  type        = string
  description = "The name of the secondary subnet where the target VM will reside"
}

variable "recovery_services_vault" {
  type        = string
  description = "The name of the Recovery services Vault in the remote region"
}

variable "replication_policy" {
  type        = string
  description = "The name of the replication policy"
}

variable "vm_name" {
  type        = string
  description = "The name of the vm to be replicated"
}