resource "proxmox_virtual_environment_sdn_zone_simple" "stacks" {
  id    = "stacks"
  nodes = ["mango"]
  dhcp  = "dnsmasq"
}

resource "proxmox_virtual_environment_sdn_vnet" "stack" {
  for_each = local.stacks

  id    = each.value.vnet
  zone  = proxmox_virtual_environment_sdn_zone_simple.stacks.id
  alias = each.key
}

resource "proxmox_virtual_environment_sdn_subnet" "stack" {
  for_each = local.stacks

  vnet    = proxmox_virtual_environment_sdn_vnet.stack[each.key].id
  cidr    = each.value.subnet
  gateway = cidrhost(each.value.subnet, 1)
  snat    = true
  dhcp_range = {
    start_address = cidrhost(each.value.subnet, 100)
    end_address   = cidrhost(each.value.subnet, 200)
  }
}

resource "proxmox_virtual_environment_sdn_applier" "stacks" {
  depends_on = [
    proxmox_virtual_environment_sdn_vnet.stack,
    proxmox_virtual_environment_sdn_subnet.stack,
  ]
}
