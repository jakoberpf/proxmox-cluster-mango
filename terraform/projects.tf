resource "openstack_identity_project_v3" "erpf_test" {
  name        = "erpf_cluster_test"
  description = "A project for testing the erpf cloud"
}

resource "openstack_identity_project_v3" "erpf_dev" {
  name        = "erpf_cluster_dev"
  description = "A project for developing the erpf cloud"
}

# resource "openstack_identity_project_v3" "erpf_domain" {
#   name        = "erpf"
#   description = "A domain for developing the erpf cloud"
#   is_domain   = true
# }
