resource "openstack_compute_instance_v2" "basic" {
  name            = "test"
  image_name      = "Cirros"
  flavor_name     = "m1.large"
  key_pair        = "jakoberpf"
  security_groups = ["default"]

  metadata = {
    this = "that"
  }

  network {
    name = "test"
  }
}

resource "openstack_compute_instance_v2" "ubuntu" {
  name            = "ubuntu"
  image_name      = "Ubuntu20.04LTS"
  flavor_name     = "m1.large"
  key_pair        = "jakoberpf"
  security_groups = ["default"]

  metadata = {
    this = "that"
  }

  network {
    name = "test"
  }
}
