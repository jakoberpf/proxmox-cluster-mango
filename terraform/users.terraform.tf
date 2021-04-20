resource "random_password" "terraform" {
  count            = 2
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "openstack_identity_user_v3" "terraform_dev" {
  default_project_id = openstack_identity_project_v3.dev.id
  name               = "terraform.dev"
  description        = "A user for terraform in the development project"

  password = random_password.terraform[0].result

  ignore_change_password_upon_first_use = true
}

resource "openstack_identity_role_assignment_v3" "role_assignment_terraform_dev" {
  user_id    = openstack_identity_user_v3.terraform_dev.id
  project_id = openstack_identity_project_v3.dev.id
  role_id    = openstack_identity_role_v3.admin.id
}

resource "openstack_identity_user_v3" "terraform_test" {
  default_project_id = openstack_identity_project_v3.test.id
  name               = "terraform.test"
  description        = "A user for terraform in the testing project"

  password = random_password.terraform[1].result

  ignore_change_password_upon_first_use = true
}

resource "openstack_identity_role_assignment_v3" "role_assignment_terraform_test" {
  user_id    = openstack_identity_user_v3.terraform_test.id
  project_id = openstack_identity_project_v3.test.id
  role_id    = openstack_identity_role_v3.admin.id
}
