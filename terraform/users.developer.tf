resource "random_password" "developers" {
  count            = 2
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "openstack_identity_user_v3" "jakob_erpf" {
  default_project_id = openstack_identity_project_v3.test.id
  name               = "jakob.erpf"
  description        = "The user for Jakob Erpf"
  password = random_password.developers[0].result
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

resource "openstack_identity_role_assignment_v3" "role_assignment_jakob_erpf" {
  user_id    = openstack_identity_user_v3.jakob_erpf.id
  project_id = openstack_identity_project_v3.test.id
  role_id    = openstack_identity_role_v3.developers.id
}
resource "openstack_identity_role_assignment_v3" "role_assignment_jakob_erpf_dev" {
  user_id    = openstack_identity_user_v3.jakob_erpf.id
  project_id = openstack_identity_project_v3.dev.id
  role_id    = openstack_identity_role_v3.developers.id
}


resource "openstack_identity_user_v3" "fabian_erpf" {
  default_project_id = openstack_identity_project_v3.test.id
  name               = "fabian.erpf"
  description        = "The user for Fabian Erpf"
  password = random_password.developers[1].result
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
  project_id = openstack_identity_project_v3.test.id
  role_id    = openstack_identity_role_v3.developers.id
}
resource "openstack_identity_role_assignment_v3" "role_assignment_fabian_erpf_dev" {
  user_id    = openstack_identity_user_v3.fabian_erpf.id
  project_id = openstack_identity_project_v3.dev.id
  role_id    = openstack_identity_role_v3.developers.id
}
