resource "openstack_identity_user_v3" "admin" {
  name = "admin"
  lifecycle {
    prevent_destroy = true
  }
}

resource "openstack_identity_role_assignment_v3" "admin_service" {
  user_id    = openstack_identity_user_v3.admin.id
  project_id = openstack_identity_project_v3.service.id
  role_id    = openstack_identity_role_v3.admin.id
  lifecycle {
    prevent_destroy = true
  }
}

resource "openstack_identity_role_assignment_v3" "admin_test" {
  user_id    = openstack_identity_user_v3.admin.id
  project_id = openstack_identity_project_v3.test.id
  role_id    = openstack_identity_role_v3.admin.id
}

resource "openstack_identity_role_assignment_v3" "admin_dev" {
  user_id    = openstack_identity_user_v3.admin.id
  project_id = openstack_identity_project_v3.dev.id
  role_id    = openstack_identity_role_v3.admin.id
}
