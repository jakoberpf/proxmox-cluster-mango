resource "local_file" "logins" {
  content = templatefile("${path.module}/templates/logins.tpl",
    {
      jakoberpf_username  = "${openstack_identity_user_v3.jakob_erpf.name}",
      jakoberpf_password  = "${openstack_identity_user_v3.jakob_erpf.password}",
      fabianerpf_username = "${openstack_identity_user_v3.fabian_erpf.name}",
      fabianerpf_password = "${openstack_identity_user_v3.fabian_erpf.password}"
    }
  )
  filename = "${path.module}/files/logins"
}
