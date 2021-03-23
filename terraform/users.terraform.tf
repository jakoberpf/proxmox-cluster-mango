# data "openstack_identity_group_v3" "terraform" {
#   name = "terraform"
# }

resource "openstack_identity_user_v3" "terraform_test" {
  default_project_id = openstack_identity_project_v3.erpf_test.id
  name               = "terraform_test"
  description        = "A user for terraform in the testing project"

  password = random_password.terraform_test.result

  ignore_change_password_upon_first_use = true
}

resource "random_password" "terraform_test" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "openstack_identity_user_v3" "terraform_dev" {
  default_project_id = openstack_identity_project_v3.erpf_dev.id
  name               = "terraform_dev"
  description        = "A user for terraform in the development project"

  password = random_password.terraform_dev.result

  ignore_change_password_upon_first_use = true
}

resource "random_password" "terraform_dev" {
  length           = 16
  special          = true
  override_special = "_%@"
}