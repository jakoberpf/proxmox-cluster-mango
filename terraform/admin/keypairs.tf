resource "openstack_compute_keypair_v2" "jakob-erpf" {
  name       = "jakoberpf"
  public_key = file("~/.ssh/id_rsa.pub")
}