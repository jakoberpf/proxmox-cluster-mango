resource "openstack_identity_role_v3" "_member_" {
  name = "_member_"
}

resource "openstack_identity_role_v3" "developers" {
  name = "developers"
}

resource "openstack_identity_role_v3" "terraform" {
  name = "terraform"
}