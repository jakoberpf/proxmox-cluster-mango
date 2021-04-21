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

# https://github.com/stackhpc/magnum-terraform/blob/master/site/upload-atomic.sh
resource "openstack_images_image_v2" "fedora_atomic" {
  name             = "fedora-atomic"
  image_source_url = "https://dl.fedoraproject.org/pub/alt/atomic/stable/Fedora-Atomic-29-20181025.1/AtomicHost/x86_64/images/Fedora-AtomicHost-29-20181025.1.x86_64.qcow2"
  container_format = "bare"
  disk_format      = "qcow2"
  visibility       = "public"
  # protected        = true
  web_download = true

  properties = {
    usage     = "kubernetes"
    os_distro = "fedora-atomic"
  }
}

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

# resource "openstack_images_image_v2" "amphora_test" {
#   name             = "amphora"
#   local_file_path  = "./images/test-only-amphora-x64-haproxy-ubuntu-bionic.qcow2"
#   container_format = "bare"
#   disk_format      = "qcow2"
#   visibility       = "shared"
#   # owner = "11b5e40d3c304ab090af75144559c632"
#   # protected        = true

#   properties = {
#     os_distro     = "ubuntu",
#     # os_admin_user = "ubuntu",
#     os_version    = "18.04",
#   }

#   tags = ["amphora"]
# }

# resource "openstack_images_image_access_v2" "rancheros_member" {
#   image_id  = openstack_images_image_v2.amphora_test.id
#   member_id = "11b5e40d3c304ab090af75144559c632"
# }

# resource "openstack_images_image_v2" "coreos" {
#   name             = "CoreOS"
#   image_source_url = "http://stable.release.core-os.net/amd64-usr/current/coreos_production_openstack_image.img.bz2"
#   container_format = "bare"
#   disk_format      = "qcow2"
#   visibility       = "public"
#   # protected        = true
#   web_download     = true

#   properties = {
#     usage = "kubernetes"
#   }
# }
