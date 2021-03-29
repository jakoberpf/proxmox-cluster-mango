resource "openstack_identity_project_v3" "test" {
  name        = "cluster_test"
  description = "A project for testing the erpf cloud"
}

resource "openstack_identity_project_v3" "dev" {
  name        = "cluster_dev"
  description = "A project for developing the erpf cloud"
}
