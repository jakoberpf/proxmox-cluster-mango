resource "openstack_images_image_v2" "rancheros" {
  name             = "RancherOS"
  image_source_url = "https://releases.rancher.com/os/latest/rancheros-openstack.img"
  container_format = "bare"
  disk_format      = "qcow2"

  properties = {
    usage = "kubernetes"
    kdist = "rke"
  }
}

resource "openstack_images_image_v2" "cirros" {
  name             = "Cirros"
  image_source_url = "http://download.cirros-cloud.net/0.5.2/cirros-0.5.2-x86_64-disk.img"
  container_format = "bare"
  disk_format      = "qcow2"

  properties = {
    usage = "testing"
  }
}

resource "openstack_images_image_v2" "ubuntu2004" {
  name             = "Ubuntu20.04"
  image_source_url = "http://archive.ubuntu.com/ubuntu/dists/focal/main/installer-amd64/"
  container_format = "bare"
  disk_format      = "qcow2"

  properties = {
    usage = "common"
  }
}