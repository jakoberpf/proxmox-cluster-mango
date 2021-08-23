# https://registry.terraform.io/providers/zerotier/zerotier/latest/docs/resources/member
# https://registry.terraform.io/providers/zerotier/zerotier/latest/docs/resources/identity

resource "zerotier_identity" "ceph" {
  count = var.node_count
}

resource "zerotier_member" "ceph" {
  count          = var.node_count
  name           = "ceph-${count.index}"
  member_id      = zerotier_identity.ceph[count.index].id
  network_id     = var.zerotier_network_id
  ip_assignments = ["10.147.19.2${count.index}"]
}
