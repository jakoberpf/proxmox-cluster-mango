resource "proxmox_virtual_environment_pool" "stack" {
  for_each = local.stacks

  pool_id = each.value.pool
  comment = "Resources of the ${each.key} stack. Managed by Terraform in proxmox/clusters/mango."
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

# Sys.AccessNetwork is required for URL downloads to datastores
# (query-url-metadata / download-url on the node).
resource "proxmox_virtual_environment_role" "stack_node" {
  role_id = "StackNode"
  privileges = [
    "Sys.Audit",
    "Sys.AccessNetwork",
  ]
}

# Pool.Allocate is required to add/remove pool members (PVEVMAdmin lacks it).
resource "proxmox_virtual_environment_role" "stack_pool" {
  role_id = "StackPool"
  privileges = [
    "Pool.Audit",
    "Pool.Allocate",
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

# Privilege-separated tokens are capped by the backing user's permissions, so
# the user needs the same grants for the token ACLs to take effect.
resource "proxmox_virtual_environment_acl" "stack_pool_user" {
  for_each = local.stacks

  path    = "/pool/${proxmox_virtual_environment_pool.stack[each.key].pool_id}"
  role_id = "PVEVMAdmin"
  user_id = proxmox_virtual_environment_user.stack[each.key].user_id
}

resource "proxmox_virtual_environment_acl" "stack_storage_vms_user" {
  for_each = local.stacks

  path    = "/storage/vms"
  role_id = proxmox_virtual_environment_role.stack_datastore.role_id
  user_id = proxmox_virtual_environment_user.stack[each.key].user_id
}

resource "proxmox_virtual_environment_acl" "stack_storage_local_user" {
  for_each = local.stacks

  path    = "/storage/local"
  role_id = proxmox_virtual_environment_role.stack_datastore.role_id
  user_id = proxmox_virtual_environment_user.stack[each.key].user_id
}

resource "proxmox_virtual_environment_acl" "stack_vnet_user" {
  for_each = local.stacks

  path    = "/sdn/zones/${proxmox_virtual_environment_sdn_zone_simple.stacks.id}/${proxmox_virtual_environment_sdn_vnet.stack[each.key].id}"
  role_id = proxmox_virtual_environment_role.stack_sdn.role_id
  user_id = proxmox_virtual_environment_user.stack[each.key].user_id
}

resource "proxmox_virtual_environment_acl" "stack_node" {
  for_each = local.stacks

  path     = "/nodes/mango"
  role_id  = proxmox_virtual_environment_role.stack_node.role_id
  token_id = proxmox_virtual_environment_user_token.stack[each.key].id
}

resource "proxmox_virtual_environment_acl" "stack_node_user" {
  for_each = local.stacks

  path    = "/nodes/mango"
  role_id = proxmox_virtual_environment_role.stack_node.role_id
  user_id = proxmox_virtual_environment_user.stack[each.key].user_id
}

resource "proxmox_virtual_environment_acl" "stack_pool_allocate" {
  for_each = local.stacks

  path     = "/pool/${proxmox_virtual_environment_pool.stack[each.key].pool_id}"
  role_id  = proxmox_virtual_environment_role.stack_pool.role_id
  token_id = proxmox_virtual_environment_user_token.stack[each.key].id
}

resource "proxmox_virtual_environment_acl" "stack_pool_allocate_user" {
  for_each = local.stacks

  path    = "/pool/${proxmox_virtual_environment_pool.stack[each.key].pool_id}"
  role_id = proxmox_virtual_environment_role.stack_pool.role_id
  user_id = proxmox_virtual_environment_user.stack[each.key].user_id
}
