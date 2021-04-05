resource "openstack_compute_flavor_v2" "m1_tiny" {
  name  = "m1.tiny"
  ram   = "512"
  vcpus = "1"
  disk  = "1"

  extra_specs = {
  }
}

resource "openstack_compute_flavor_v2" "m1_small" {
  name  = "m1.small"
  ram   = "2048"
  vcpus = "2"
  disk  = "10"

  extra_specs = {
  }
}

resource "openstack_compute_flavor_v2" "m1_medium" {
  name  = "m1.medium"
  ram   = "4096"
  vcpus = "4"
  disk  = "20"

  extra_specs = {
  }
}

resource "openstack_compute_flavor_v2" "m1_large" {
  name  = "m1.large"
  ram   = "8192"
  vcpus = "4"
  disk  = "40"

  extra_specs = {
  }
}

resource "openstack_compute_flavor_v2" "m1_xlarge" {
  name  = "m1.xlarge"
  ram   = "16384"
  vcpus = "4"
  disk  = "80"

  extra_specs = {
  }
}