### The SSH config file
resource "local_file" "SshConfig" {
 content = templatefile("files/ssh-config.tpl",
 {
  mon-ip = proxmox_vm_qemu.ceph_mon.*.default_ipv4_address,
  mon-id = proxmox_vm_qemu.ceph_mon.*.name,
  mon-user = "automation",
 }
 )
 filename = ".ssh/config"
}