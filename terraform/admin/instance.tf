resource "openstack_compute_instance_v2" "bastion" {
  name            = "ubuntu"
  image_name      = "Ubuntu20.04LTS"
  flavor_name     = "m1.small"
  key_pair        = "jakoberpf"
  security_groups = ["icmp","ssh"]

  metadata = {
    this = "that"
  }

  network {
    name = openstack_networking_network_v2.test.name
  }

  depends_on = [
    openstack_networking_subnet_v2.admin_subnet
  ]
}
