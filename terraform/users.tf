resource "proxmox_virtual_environment_pool" "stack" {
  for_each = local.stacks

  pool_id = each.value.pool
  comment = "Resources of the ${each.key} stack. Managed by Terraform in devops/proxmox/cluster-mango."
}

resource "proxmox_virtual_environment_user" "stack" {
  for_each = local.stacks

  user_id = "svc-${each.key}@pve"
  enabled = true
  comment = "Service identity for the ${each.key} stack repository."
}

resource "proxmox_virtual_environment_user_token" "stack" {
  for_each = local.stacks

  user_id               = proxmox_virtual_environment_user.stack[each.key].user_id
  token_name            = "terraform"
  privileges_separation = true
}

resource "proxmox_virtual_environment_role" "stack_datastore" {
  role_id = "StackDatastore"
  privileges = [
    "Datastore.Allocate",
    "Datastore.AllocateSpace",
    "Datastore.AllocateTemplate",
    "Datastore.Audit",
  ]
}

resource "proxmox_virtual_environment_role" "stack_sdn" {
  role_id = "StackSDN"
  privileges = [
    "SDN.Use",
    "SDN.Audit",
  ]
}

resource "proxmox_virtual_environment_acl" "stack_pool" {
  for_each = local.stacks

  path     = "/pool/${proxmox_virtual_environment_pool.stack[each.key].pool_id}"
  role_id  = "PVEVMAdmin"
  token_id = proxmox_virtual_environment_user_token.stack[each.key].id
}

resource "proxmox_virtual_environment_acl" "stack_storage_vms" {
  for_each = local.stacks

  path     = "/storage/vms"
  role_id  = proxmox_virtual_environment_role.stack_datastore.role_id
  token_id = proxmox_virtual_environment_user_token.stack[each.key].id
}

resource "proxmox_virtual_environment_acl" "stack_storage_local" {
  for_each = local.stacks

  path     = "/storage/local"
  role_id  = proxmox_virtual_environment_role.stack_datastore.role_id
  token_id = proxmox_virtual_environment_user_token.stack[each.key].id
}

resource "proxmox_virtual_environment_acl" "stack_vnet" {
  for_each = local.stacks

  path     = "/sdn/zones/${proxmox_virtual_environment_sdn_zone_simple.stacks.id}/${proxmox_virtual_environment_sdn_vnet.stack[each.key].id}"
  role_id  = proxmox_virtual_environment_role.stack_sdn.role_id
  token_id = proxmox_virtual_environment_user_token.stack[each.key].id
}
