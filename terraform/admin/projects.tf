resource "openstack_identity_project_v3" "service" {
  name        = "service"
  description = ""
  lifecycle {
    prevent_destroy = true
  }
}

resource "openstack_identity_project_v3" "dev" {
  name        = "development"
  description = "A project for developing"
}
resource "openstack_identity_project_v3" "test" {
  name        = "testing"
  description = "A project for testing"
}
resource "openstack_identity_project_v3" "live" {
  name        = "production"
  description = "A project for production"
}

# https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/compute_quotaset_v2
resource "openstack_compute_quotaset_v2" "dev" {
  project_id           = "${openstack_identity_project_v3.dev.id}"
  ram                  = 40960
  cores                = 64
  instances            = 20
  server_groups        = 4
  server_group_members = 8
}
resource "openstack_compute_quotaset_v2" "test" {
  project_id           = "${openstack_identity_project_v3.test.id}"
  ram                  = 40960
  cores                = 64
  instances            = 20
  server_groups        = 4
  server_group_members = 8
}
resource "openstack_compute_quotaset_v2" "live" {
  project_id           = "${openstack_identity_project_v3.live.id}"
  key_pairs            = 1
  ram                  = 40960
  cores                = 256
  instances            = 20
  server_groups        = 4
  server_group_members = 8
}