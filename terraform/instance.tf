resource "openstack_compute_instance_v2" "bastion" {
  name            = "ubuntu"
  image_name      = "Ubuntu20.04LTS"
  flavor_name     = "m1.tiny"
  key_pair        = "jakoberpf"
  security_groups = ["default"]

  metadata = {
    this = "that"
  }

  network {
    name = "test"
  }

  depends_on = [
    openstack_networking_subnet_v2.admin_subnet
  ]
}
