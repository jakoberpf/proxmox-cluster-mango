resource "openstack_identity_project_v3" "service" {
  name        = "service"
  description = ""
  lifecycle {
    prevent_destroy = true
  }
}
resource "openstack_identity_project_v3" "test" {
  name        = "testing"
  description = "A project for testing the ERPF cloud"
}

resource "openstack_identity_project_v3" "dev" {
  name        = "development"
  description = "A project for developing the ERPF cloud"
}
