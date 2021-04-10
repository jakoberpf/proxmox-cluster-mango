# Official sources for images: https://docs.openstack.org/image-guide/obtain-images.html

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

resource "openstack_images_image_v2" "ubuntu18-04" {
  name             = "Ubuntu18.04LTS"
  image_source_url = "https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img"
  container_format = "bare"
  disk_format      = "qcow2"

  properties = {
    usage = "common"
  }
}

resource "openstack_images_image_v2" "ubuntu20-04" {
  name             = "Ubuntu20.04LTS"
  image_source_url = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img"
  container_format = "bare"
  disk_format      = "qcow2"

  properties = {
    usage = "common"
  }
}

resource "openstack_images_image_v2" "ubuntu20-10" {
  name             = "Ubuntu20.10STR"
  image_source_url = "https://cloud-images.ubuntu.com/groovy/current/groovy-server-cloudimg-amd64.img"
  container_format = "bare"
  disk_format      = "qcow2"

  properties = {
    usage = "common"
  }
}