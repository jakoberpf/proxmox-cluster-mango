resource "openstack_identity_role_v3" "admin" {
  name = "admin"
  lifecycle {
    prevent_destroy = true
  }
}
resource "openstack_identity_role_v3" "developers" {
  name = "developers"
}
