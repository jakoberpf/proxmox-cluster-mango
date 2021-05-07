# Official sources for images: https://docs.openstack.org/image-guide/obtain-images.html

resource "openstack_images_image_v2" "rancheros" {
  name             = "RancherOS"
  image_source_url = "https://releases.rancher.com/os/latest/rancheros-openstack.img"
  container_format = "bare"
  disk_format      = "qcow2"
  visibility       = "public"
  # protected        = true
  web_download = true

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
  visibility       = "public"
  # protected        = true
  web_download = true

  properties = {
    usage = "testing"
  }
}

resource "openstack_images_image_v2" "ubuntu18-04" {
  name             = "Ubuntu18.04LTS"
  image_source_url = "https://cloud-images.ubuntu.com/bionic/current/bionic-server-cloudimg-amd64.img"
  container_format = "bare"
  disk_format      = "qcow2"
  visibility       = "public"
  # protected        = true
  web_download = true

  properties = {
    usage = "common"
  }
}

resource "openstack_images_image_v2" "ubuntu20-04" {
  name             = "Ubuntu20.04LTS"
  image_source_url = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64.img"
  container_format = "bare"
  disk_format      = "qcow2"
  visibility       = "public"
  # protected        = true
  web_download = true

  properties = {
    usage = "common"
  }
}

resource "openstack_images_image_v2" "ubuntu20-10" {
  name             = "Ubuntu20.10STR"
  image_source_url = "https://cloud-images.ubuntu.com/groovy/current/groovy-server-cloudimg-amd64.img"
  container_format = "bare"
  disk_format      = "qcow2"
  visibility       = "public"
  # protected        = true
  web_download = true

  properties = {
    usage = "common"
  }
}

resource "openstack_images_image_v2" "fedora33" {
  name             = "Fedora33"
  image_source_url = "https://download.fedoraproject.org/pub/fedora/linux/releases/33/Cloud/x86_64/images/Fedora-Cloud-Base-33-1.2.x86_64.qcow2"
  container_format = "bare"
  disk_format      = "qcow2"
  visibility       = "public"
  # protected        = true
  web_download = true

  properties = {
    usage = "kubernetes"
  }
}

# # https://github.com/stackhpc/magnum-terraform/blob/master/site/upload-atomic.sh
# resource "openstack_images_image_v2" "fedora_atomic" {
#   name             = "fedora-atomic"
#   image_source_url = "https://dl.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-29-20181025.1/AtomicHost/x86_64/images/Fedora-AtomicHost-29-20181025.1.x86_64.qcow2"
#   container_format = "bare"
#   disk_format      = "qcow2"
#   visibility       = "public"
#   # protected        = true
#   web_download = true

#   properties = {
#     usage     = "kubernetes"
#     os_distro = "fedora-atomic"
#   }
# }

resource "openstack_images_image_v2" "fedora_coreos" {
  name             = "fedora-coreos"
  image_source_url = "https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/33.20210328.3.0/x86_64/fedora-coreos-33.20210328.3.0-openstack.x86_64.qcow2.xz"
  container_format = "bare"
  disk_format      = "qcow2"
  visibility       = "public"
  # protected        = true
  web_download = true

  properties = {
    usage     = "kubernetes"
    os_distro = "fedora-coreos"
  }
}
