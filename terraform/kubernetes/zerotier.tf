# https://registry.terraform.io/providers/zerotier/zerotier/latest/docs/resources/member
# https://registry.terraform.io/providers/zerotier/zerotier/latest/docs/resources/identity

# resource "zerotier_identity" "kubernetes" {}

# resource "zerotier_member" "kubernetes" {
#   name           = "kubernetes"
#   member_id      = zerotier_identity.microstack.id
#   network_id     = var.zerotier_network_id
#   ip_assignments = [var.zerotier_openstack_ip]
# }
