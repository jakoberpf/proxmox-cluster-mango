# resource "openstack_identity_user_v3" "admin" {
#   name = "admin"
# }

# resource "openstack_identity_role_assignment_v3" "role_assignment_admin_test" {
#   user_id    = openstack_identity_user_v3.admin.id
#   project_id = openstack_identity_project_v3.test.id
#   role_id    = openstack_identity_role_v3.admin.id
# }

# resource "openstack_identity_role_assignment_v3" "role_assignment_admin_dev" {
#   user_id    = openstack_identity_user_v3.admin.id
#   project_id = openstack_identity_project_v3.dev.id
#   role_id    = openstack_identity_role_v3.admin.id
# }
