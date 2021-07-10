# Source the Cloud Init Config file
data "template_file" "cloud_init_ubuntu_bitbucket_runner" {
  template = file("${path.module}/files/cloud_init_ubuntu_bitbucket_runner.cloud_config")

  vars = {
    ssh_key              = file("~/.ssh/id_rsa.pub")
    zerotier_network_id  = var.zerotier_network_id
    zerotier_public_key  = zerotier_identity.bitbucket_runner.public_key
    zerotier_private_key = zerotier_identity.bitbucket_runner.private_key
  }
}

# Create a local copy of the file, to transfer to Proxmox
resource "local_file" "cloud_init_ubuntu_bitbucket_runner" {
  content  = data.template_file.cloud_init_ubuntu_bitbucket_runner.rendered
  filename = "${path.module}/files/cloud_init_ubuntu_bitbucket_runner.cfg"
}

# Transfer the file to the Proxmox Host
resource "null_resource" "cloud_init_ubuntu_bitbucket_runner" {
  connection {
    type     = "ssh"
    user     = "root"
    password = "proxmox"
    host     = "10.147.19.60"
  }

  provisioner "file" {
    source      = local_file.cloud_init_ubuntu_bitbucket_runner.filename
    destination = "/var/lib/vz/snippets/cloud_init_ubuntu_bitbucket_runner.yml"
  }
}

resource "proxmox_vm_qemu" "bitbucket_runner" {
  ## Wait for the cloud-config file to exist
  depends_on = [
    null_resource.cloud_init_ubuntu_bitbucket_runner
  ]

  name        = "bitbucket-runner"
  vmid        = "501"
  target_node = "pve"

  # Clone from debian-cloudinit template
  clone   = "ubuntu-focal-cloudinit"
  os_type = "cloud-init"

  # Cloud init options
  ipconfig0  = "ip=192.168.2.101/22,gw=192.168.1.1"
  cicustom   = "user=local:snippets/cloud_init_ubuntu_bitbucket_runner.yml"

  memory = 16000
  cores = 8
  agent  = 1

  # Set the boot disk paramters
  bootdisk = "virtio0"
  scsihw   = "virtio-scsi-pci"

  disk {
    size    = "80G"
    type    = "virtio"
    storage = "local-lvm"
  }

  # Set the network
  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  # Ignore changes to the network
  ## MAC address is generated on every apply, causing
  ## TF to think this needs to be rebuilt on every apply
  lifecycle {
    ignore_changes = [
      network
    ]
  }

  guest_agent_ready_timeout = 60
}