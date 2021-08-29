# ### The Ansible inventory file
# resource "local_file" "AnsibleInventory" {
#  content = templatefile("templates/inventory.tpl",
#  {
# #   bastion-ip = zerotier_member.bastion.ip_assignments.0,
# #   bastion-id = openstack_compute_instance_v2.bastion.name,
# #   bastion-user = "ubuntu",
#   mon-ip = proxmox_vm_qemu.ceph_mon.*.default_ipv4_address,
#   mon-id = proxmox_vm_qemu.ceph_mon.*.name,
#   mon-user = "automation",
# #   workers-ip = openstack_compute_instance_v2.worker.*.access_ip_v4,
# #   workers-id = openstack_compute_instance_v2.worker.*.name,
# #   workers-user = "ubuntu"
#  }
#  )
#  filename = "./inventory"
# }