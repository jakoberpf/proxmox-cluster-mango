resource "openstack_compute_flavor_v2" "m1_tiny" {
  name      = "m1.tiny"
  ram       = "2048"
  vcpus     = "1"
  disk      = "2"
  is_public = true
}

resource "openstack_compute_flavor_v2" "m1_small" {
  name      = "m1.small"
  ram       = "4096"
  vcpus     = "2"
  disk      = "4"
  is_public = true
}

resource "openstack_compute_flavor_v2" "m1_medium" {
  name      = "m1.medium"
  ram       = "8192"
  vcpus     = "4"
  disk      = "8"
  is_public = true
}

resource "openstack_compute_flavor_v2" "m1_large" {
  name      = "m1.large"
  ram       = "16384"
  vcpus     = "8"
  disk      = "16"
  is_public = true
}