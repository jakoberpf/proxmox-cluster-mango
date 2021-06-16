# https://registry.terraform.io/providers/zerotier/zerotier/latest/docs/resources/member
# https://registry.terraform.io/providers/zerotier/zerotier/latest/docs/resources/identity

resource "zerotier_identity" "proxmox" {}

resource "zerotier_member" "proxmox" {
  name           = "proxmox"
  member_id      = zerotier_identity.proxmox.id
  network_id     = var.zerotier_network_id
  ip_assignments = [var.zerotier_proxmox_ip]
}

output "private_key" {
  sensitive = true
  value     = zerotier_identity.proxmox.private_key
}

output "public_key" {
  value = zerotier_identity.proxmox.public_key
}
