resource "openstack_compute_flavor_v2" "m2_tiny" {
  name      = "m2.tiny"
  ram       = "1024"
  vcpus     = "1"
  disk      = "2"
  is_public = true
}

resource "openstack_compute_flavor_v2" "m2_small" {
  name      = "m2.small"
  ram       = "4048"
  vcpus     = "2"
  disk      = "10"
  is_public = true
}

resource "openstack_compute_flavor_v2" "m2_medium" {
  name      = "m2.medium"
  ram       = "8096"
  vcpus     = "2"
  disk      = "20"
  is_public = true
}

resource "openstack_compute_flavor_v2" "m2_large" {
  name      = "m2.large"
  ram       = "16192"
  vcpus     = "4"
  disk      = "40"
  is_public = true
}
