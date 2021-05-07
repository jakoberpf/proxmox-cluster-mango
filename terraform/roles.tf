resource "openstack_identity_role_v3" "admin" {
  name = "admin"
}
resource "openstack_identity_role_v3" "developers" {
  name = "developers"
}
