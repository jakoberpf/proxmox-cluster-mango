resource "random_password" "developers" {
  count            = 3
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
    email = "jakob@erpf.de"
  }
}
resource "openstack_identity_role_assignment_v3" "role_assignment_jakob_erpf_dev" {
  user_id    = openstack_identity_user_v3.jakob_erpf.id
  project_id = openstack_identity_project_v3.dev.id
  role_id    = openstack_identity_role_v3.developers.id
}
resource "openstack_identity_role_assignment_v3" "role_assignment_jakob_erpf_test" {
  user_id    = openstack_identity_user_v3.jakob_erpf.id
  project_id = openstack_identity_project_v3.test.id
  role_id    = openstack_identity_role_v3.developers.id
}
resource "openstack_identity_role_assignment_v3" "role_assignment_jakob_erpf_live" {
  user_id    = openstack_identity_user_v3.jakob_erpf.id
  project_id = openstack_identity_project_v3.live.id
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
    email = "fabian@erpf.de"
  }
}
resource "openstack_identity_role_assignment_v3" "role_assignment_fabian_erpf_dev" {
  user_id    = openstack_identity_user_v3.fabian_erpf.id
  project_id = openstack_identity_project_v3.dev.id
  role_id    = openstack_identity_role_v3.developers.id
}
resource "openstack_identity_role_assignment_v3" "role_assignment_fabian_erpf_test" {
  user_id    = openstack_identity_user_v3.fabian_erpf.id
  project_id = openstack_identity_project_v3.test.id
  role_id    = openstack_identity_role_v3.developers.id
}

resource "openstack_identity_user_v3" "david_koch" {
  default_project_id = openstack_identity_project_v3.test.id
  name               = "david.koch"
  description        = "The user for David Koch"
  password = random_password.developers[2].result
  ignore_change_password_upon_first_use = true
  multi_factor_auth_enabled = true

  multi_factor_auth_rule {
    rule = ["password", "totp"]
  }

  multi_factor_auth_rule {
    rule = ["password"]
  }

  extra = {
    email = "david@erpf.de"
  }
}
resource "openstack_identity_role_assignment_v3" "role_assignment_david_koch_dev" {
  user_id    = openstack_identity_user_v3.fabian_erpf.id
  project_id = openstack_identity_project_v3.dev.id
  role_id    = openstack_identity_role_v3.developers.id
}
resource "openstack_identity_role_assignment_v3" "role_assignment_david_koch_test" {
  user_id    = openstack_identity_user_v3.fabian_erpf.id
  project_id = openstack_identity_project_v3.test.id
  role_id    = openstack_identity_role_v3.developers.id
}