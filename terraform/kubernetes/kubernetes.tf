# Source the Cloud Init Config file
data "template_file" "cloud_init_ubuntu_kubernetes" {
  count = var.node_count
  template = file("${path.module}/files/cloud_init_ubuntu_kubernetes.cloud_config")
  vars = {
    ssh_key              = file("~/.ssh/id_rsa.pub")
    zerotier_network_id  = var.zerotier_network_id
    zerotier_public_key  = zerotier_identity.kubernetes[count.index].public_key
    zerotier_private_key = zerotier_identity.kubernetes[count.index].private_key
  }
}

# Create a local copy of the file, to transfer to Proxmox
resource "local_file" "cloud_init_ubuntu_kubernetes" {
  count = var.node_count
  content  = data.template_file.cloud_init_ubuntu_kubernetes[count.index].rendered
  filename = "${path.module}/files/cloud_init_ubuntu_kubernetes_${count.index}.cfg"
}

# Transfer the file to the Proxmox Host
resource "null_resource" "cloud_init_ubuntu_kubernetes" {
  count = var.node_count
  connection {
    type     = "ssh"
    user     = "root"
    password = "proxmox"
    host     = "10.147.19.60"
  }

  provisioner "file" {
    source      = local_file.cloud_init_ubuntu_kubernetes[count.index].filename
    destination = "/var/lib/vz/snippets/cloud_init_ubuntu_kubernetes_${count.index}.yml"
  }

  provisioner "remote-exec" {
    when = destroy
    inline = [
      "rm /var/lib/vz/snippets/cloud_init_ubuntu_kubernetes_${count.index}.yml",
    ]
  }
}

resource "proxmox_vm_qemu" "kubernetes" {
  count = var.node_count
  ## Wait for the cloud-config file to exist
  depends_on = [
    null_resource.cloud_init_ubuntu_kubernetes
  ]

  name        = "kubernetes-${count.index}"
  vmid        = "23${count.index}"
  target_node = "pve"

  # Clone from debian-cloudinit template
  clone   = "ubuntu-focal-cloudinit"
  os_type = "cloud-init"

  # Cloud init options
  ipconfig0  = "ip=192.168.2.11${count.index}/22,gw=192.168.1.1"
  cicustom   = "user=local:snippets/cloud_init_ubuntu_kubernetes_${count.index}.yml"

  memory = 16000
  cores = 8
  agent  = 1

  # Set the boot disk paramters
  bootdisk = "virtio0"
  scsihw   = "virtio-scsi-pci"

  disk {
    size    = "20G"
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