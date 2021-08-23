# https://registry.terraform.io/providers/zerotier/zerotier/latest/docs/resources/member
# https://registry.terraform.io/providers/zerotier/zerotier/latest/docs/resources/identity

resource "zerotier_identity" "ceph_mon" {
  count = var.node_count_mon
}
resource "zerotier_identity" "ceph_osd" {
  count = var.node_count_osd
}

resource "zerotier_member" "ceph_mon" {
  count          = var.node_count_mon
  name           = "ceph_mon-${count.index}"
  member_id      = zerotier_identity.ceph_mon[count.index].id
  network_id     = var.zerotier_network_id
  ip_assignments = ["10.147.19.2${count.index}"]
}
resource "zerotier_member" "ceph_osd" {
  count          = var.node_count_osd
  name           = "ceph_osd-${count.index}"
  member_id      = zerotier_identity.ceph_osd[count.index].id
  network_id     = var.zerotier_network_id
  ip_assignments = ["10.147.19.2${count.index}"]
}


