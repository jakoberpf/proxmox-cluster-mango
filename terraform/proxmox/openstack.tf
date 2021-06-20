# Source the Cloud Init Config file
data "template_file" "cloud_init_ubuntu" {
  template = file("${path.module}/files/cloud_init_ubuntu.cloud_config")

  vars = {
    ssh_key              = file("~/.ssh/id_rsa.pub")
    zerotier_network_id  = var.zerotier_network_id
    zerotier_public_key  = zerotier_identity.openstack.public_key
    zerotier_private_key = zerotier_identity.openstack.private_key
  }
}

# Create a local copy of the file, to transfer to Proxmox
resource "local_file" "cloud_init_ubuntu" {
  content  = data.template_file.cloud_init_ubuntu.rendered
  filename = "${path.module}/files/cloud_init_ubuntu.cfg"
}

# Transfer the file to the Proxmox Host
resource "null_resource" "cloud_init_ubuntu" {
  connection {
    type     = "ssh"
    user     = "root"
    password = "proxmox"
    host     = "10.147.19.60"
  }

  provisioner "file" {
    source      = local_file.cloud_init_ubuntu.filename
    destination = "/var/lib/vz/snippets/cloud_init_ubuntu.yml"
  }
}


# Create the VM
resource "proxmox_vm_qemu" "vm-01" {
  ## Wait for the cloud-config file to exist

  depends_on = [
    null_resource.cloud_init_ubuntu
  ]

  name        = "openstack-01"
  target_node = "pve"

  # Clone from debian-cloudinit template
  clone   = "ubuntu-focal-cloudinit"
  os_type = "cloud-init"

  # Cloud init options
  ipconfig0  = "ip=192.168.1.45/22,gw=192.168.1.1"
  cicustom   = "user=local:snippets/cloud_init_ubuntu.yml"
  # ciuser     = "jakoberpf"
  # cipassword = "jakoberpf"
  # sshkeys    = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDg+z06lsnTQDGdW2Q3m1MTNLoW9dKOHmGwjTBSnMj/JBkOBx5TEeBuv7IR5K1vkiSVqEsECrz6V6gNAMUb+56jEAsjgkvF/OwDG7g5hwfzDuar64+sQWosPAF0qUDeVd6+LSg/BnxUc4Koj6nUxX/lImyAhXCKTNsYm/LMyBysJeZD01TyHHjoHTmHQyXqSFKoJaFm2i1FBcrmtv/zsoXDKqRNn0Q1vrBYzc9AW92Ecmrnns3MVGW1QXvx3lVNrQ9s2aIyYxfWK2H321Z2eP44g5+UGp3YNBB2U3hUYmtZBjWAXeaKoqdeBO0t2pwpsh33qcdiW+Bmqy7R7x1LF9OX jakoberpf@jakoberpf.de"
  

  memory = 2048
  agent  = 1

  # Set the boot disk paramters
  bootdisk = "scsi0"
  scsihw   = "virtio-scsi-pci"

  disk {
    # id              = 0
    size    = "11G"
    type    = "scsi"
    storage = "local-lvm"
    # storage_type    = "lvm"
    # iothread        = true
  }

  # Set the network
  network {
    # id = 0
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
