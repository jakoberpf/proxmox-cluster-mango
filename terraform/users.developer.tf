# data "openstack_identity_group_v3" "developer_testing" {
#   name = "developer-testing"
# }

# data "openstack_identity_group_v3" "developer_development" {
#   name = "developer-development"
# }

resource "openstack_identity_user_v3" "fabian_erpf" {
  default_project_id = openstack_identity_project_v3.erpf_test.id
  name               = "fabian.erpf"
  description        = "The testing user for Fabian Erpf"

  password = random_password.terraform_test.result

  ignore_change_password_upon_first_use = true

  multi_factor_auth_enabled = true

  multi_factor_auth_rule {
    rule = ["password", "totp"]
  }

  multi_factor_auth_rule {
    rule = ["password"]
  }

  extra = {
    email = "fabschke@live.de"
  }
}

resource "openstack_identity_role_assignment_v3" "role_assignment_fabian_erpf" {
  user_id    = openstack_identity_user_v3.fabian_erpf.id
  project_id = openstack_identity_project_v3.erpf_test.id
  role_id    = openstack_identity_role_v3.developers.id
}

resource "random_password" "fabian_erpf" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "openstack_identity_user_v3" "jakob_erpf" {
  default_project_id = openstack_identity_project_v3.erpf_test.id
  name               = "jakob.erpf"
  description        = "The testing user for Jakob Erpf"

  password = random_password.terraform_test.result

  ignore_change_password_upon_first_use = true

  multi_factor_auth_enabled = true

  multi_factor_auth_rule {
    rule = ["password", "totp"]
  }

  multi_factor_auth_rule {
    rule = ["password"]
  }

  extra = {
    email = "contact@jakoberpf.de"
  }
}

resource "random_password" "jakob_erpf" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "openstack_identity_role_assignment_v3" "role_assignment_jakob_erpf" {
  user_id    = openstack_identity_user_v3.jakob_erpf.id
  project_id = openstack_identity_project_v3.erpf_test.id
  role_id    = openstack_identity_role_v3.developers.id
}
