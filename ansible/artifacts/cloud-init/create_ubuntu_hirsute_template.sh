# Navigate to the ISO directory for Proxmox
cd /var/lib/vz/template/iso

# Source the image
wget https://cloud-images.ubuntu.com/hirsute/current/hirsute-server-cloudimg-amd64.img

apt-get install libguestfs-tools
virt-customize -a hirsute-server-cloudimg-amd64.img --install qemu-guest-agent

# Create the instance
qm create 9002 -name ubuntu-hirsute-cloudinit -memory 1024 -net0 virtio,bridge=vmbr0 -cores 1 -sockets 1

# Import the OpenStack disk image to Proxmox storage
qm importdisk 9002 hirsute-server-cloudimg-amd64.img local-lvm

# Attach the disk to the virtual machine
qm set 9002 -scsihw virtio-scsi-pci -virtio0 local-lvm:vm-9002-disk-0

# Add a serial output
qm set 9002 -serial0 socket

# Set the bootdisk to the imported Openstack disk
qm set 9002 -boot c -bootdisk virtio0

# Enable the Qemu agent
qm set 9002 -agent 1

# Allow hotplugging of network, USB and disks
qm set 9002 -hotplug disk,network,usb

# Add a single vCPU (for now)
qm set 9002 -vcpus 1

# Add a video output
qm set 9002 -vga qxl

# Set a second hard drive, using the inbuilt cloudinit drive
qm set 9002 -ide2 local-lvm:cloudinit

# Resize the primary boot disk (otherwise it will be around 2G by default)
# This step adds another 8G of disk space, but change this as you need to
qm resize 9002 virtio0 +8G

# Convert the VM to the template
qm template 9002