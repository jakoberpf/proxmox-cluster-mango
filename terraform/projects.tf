resource "openstack_identity_project_v3" "live" {
  name        = "cluster_live"
  description = "A project for the production ERPF cloud"
}
resource "openstack_identity_project_v3" "test" {
  name        = "cluster_test"
  description = "A project for testing the ERPF cloud"
}

resource "openstack_identity_project_v3" "dev" {
  name        = "cluster_dev"
  description = "A project for developing the ERPF cloud"
}
