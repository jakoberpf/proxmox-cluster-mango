resource "openstack_compute_flavor_v2" "c1_tiny" {
  name      = "c1.tiny"
  ram       = "1024"
  vcpus     = "2"
  disk      = "2"
  is_public = true
}

resource "openstack_compute_flavor_v2" "c1_small" {
  name      = "c1.small"
  ram       = "2048"
  vcpus     = "4"
  disk      = "4"
  is_public = true
}

resource "openstack_compute_flavor_v2" "c1_medium" {
  name      = "c1.medium"
  ram       = "4096"
  vcpus     = "8"
  disk      = "8"
  is_public = true
}

resource "openstack_compute_flavor_v2" "c1_large" {
  name      = "c1.large"
  ram       = "8192"
  vcpus     = "16"
  disk      = "16"
  is_public = true
}