# https://registry.terraform.io/providers/zerotier/zerotier/latest/docs/resources/member
# https://registry.terraform.io/providers/zerotier/zerotier/latest/docs/resources/identity

resource "zerotier_identity" "ceph_mon" {
  count = var.node_count_mon
}
resource "zerotier_identity" "ceph_monitoring" {
  count = var.node_count_monitoring
}
resource "zerotier_identity" "ceph_mgrs" {
  count = var.node_count_mgrs
}
resource "zerotier_identity" "ceph_osd" {
  count = var.node_count_osd
}
resource "zerotier_identity" "ceph_rgws" {
  count = var.node_count_rgws
}

resource "zerotier_member" "ceph_mon" {
  count          = var.node_count_mon
  name           = "ceph_mon-${count.index}"
  member_id      = zerotier_identity.ceph_mon[count.index].id
  network_id     = var.zerotier_network_id
  ip_assignments = ["10.147.20.2${count.index}"]
}
resource "zerotier_member" "ceph_monitoring" {
  count          = var.node_count_monitoring
  name           = "ceph_monitoring-${count.index}"
  member_id      = zerotier_identity.ceph_monitoring[count.index].id
  network_id     = var.zerotier_network_id
  ip_assignments = ["10.147.20.3${count.index}"]
}
resource "zerotier_member" "ceph_mgrs" {
  count          = var.node_count_mgrs
  name           = "ceph_mgrs-${count.index}"
  member_id      = zerotier_identity.ceph_mgrs[count.index].id
  network_id     = var.zerotier_network_id
  ip_assignments = ["10.147.20.4${count.index}"]
}
resource "zerotier_member" "ceph_osd" {
  count          = var.node_count_osd
  name           = "ceph_osd-${count.index}"
  member_id      = zerotier_identity.ceph_osd[count.index].id
  network_id     = var.zerotier_network_id
  ip_assignments = ["10.147.20.5${count.index}"]
}
resource "zerotier_member" "ceph_rgws" {
  count          = var.node_count_rgws
  name           = "ceph_rgws-${count.index}"
  member_id      = zerotier_identity.ceph_rgws[count.index].id
  network_id     = var.zerotier_network_id
  ip_assignments = ["10.147.20.6${count.index}"]
}


