# https://registry.terraform.io/providers/zerotier/zerotier/latest/docs/resources/member
# https://registry.terraform.io/providers/zerotier/zerotier/latest/docs/resources/identity

resource "zerotier_identity" "openstack" {}

resource "zerotier_member" "openstack" {
  name           = "openstack"
  member_id      = zerotier_identity.openstack.id
  network_id     = var.zerotier_network_id
  ip_assignments = [var.zerotier_openstack_ip]
}
