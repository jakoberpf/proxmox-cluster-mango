# https://registry.terraform.io/providers/zerotier/zerotier/latest/docs/resources/member
# https://registry.terraform.io/providers/zerotier/zerotier/latest/docs/resources/identity

resource "zerotier_identity" "kubernetes" {
  count = var.node_count
}

resource "zerotier_member" "kubernetes" {
  count          = var.node_count
  name           = "kubernetes-${count.index}"
  member_id      = zerotier_identity.kubernetes[count.index].id
  network_id     = var.zerotier_network_id
  ip_assignments = ["10.147.19.5${count.index}"]
}
