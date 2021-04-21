resource "openstack_images_image_v2" "amphora_test" {
  name             = "amphora"
  local_file_path  = "./images/test-only-amphora-x64-haproxy-ubuntu-bionic.qcow2"
  container_format = "bare"
  disk_format      = "qcow2"
  visibility       = "private"
  # protected        = true

  properties = {
    os_distro     = "ubuntu",
    # os_admin_user = "ubuntu",
    os_version    = "18.04",
  }

  tags = ["amphora"]
}
