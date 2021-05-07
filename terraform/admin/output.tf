resource "local_file" "logins" {
  content = templatefile("${path.module}/templates/logins.tpl",
    {
      jakoberpf_username      = openstack_identity_user_v3.jakob_erpf.name,
      jakoberpf_password      = openstack_identity_user_v3.jakob_erpf.password,
      fabianerpf_username     = openstack_identity_user_v3.fabian_erpf.name,
      fabianerpf_password     = openstack_identity_user_v3.fabian_erpf.password
      terraform_dev_username  = openstack_identity_user_v3.terraform_dev.name,
      terraform_dev_password  = openstack_identity_user_v3.terraform_dev.password,
      terraform_test_username = openstack_identity_user_v3.terraform_test.name,
      terraform_test_password = openstack_identity_user_v3.terraform_test.password
    }
  )
  filename = "${path.module}/files/logins"
}
