resource "zerotier_identity" "proxmox" {}

resource "zerotier_member" "proxmox" {
  name       = "proxmox-development"
  member_id  = zerotier_identity.proxmox.id
  network_id = var.zerotier_network_id_development
  ip_assignments = [
    var.zerotier_member_ip_development
  ]
}

resource "local_file" "private_key" {
  content  = zerotier_identity.proxmox.private_key
  filename = "../ansible/artifacts/zerotier/identity.secret"
}

resource "local_file" "public_key" {
  content  = zerotier_identity.proxmox.public_key
  filename = "../ansible/artifacts/zerotier/identity.public"
}
