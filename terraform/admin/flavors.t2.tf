resource "openstack_compute_flavor_v2" "t1_tiny" {
  name      = "t1.tiny"
  ram       = "1024"
  vcpus     = "1"
  disk      = "2"
  is_public = true
}

resource "openstack_compute_flavor_v2" "t1_small" {
  name      = "t1.small"
  ram       = "2048"
  vcpus     = "2"
  disk      = "4"
  is_public = true
}

resource "openstack_compute_flavor_v2" "t1_medium" {
  name      = "t1.medium"
  ram       = "4096"
  vcpus     = "4"
  disk      = "8"
  is_public = true
}

resource "openstack_compute_flavor_v2" "t1_large" {
  name      = "t1.large"
  ram       = "8192"
  vcpus     = "8"
  disk      = "16"
  is_public = true
}

resource "openstack_compute_flavor_v2" "t1_xlarge" {
  name      = "t1.xlarge"
  ram       = "16384"
  vcpus     = "16"
  disk      = "32"
  is_public = true
}
