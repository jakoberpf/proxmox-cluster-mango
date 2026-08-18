# GPU passthrough

The AMD RX 6600 XT is currently owned by the Proxmox host (`amdgpu` plus
`snd_hda_intel`). No VM currently has a `hostpci` assignment. The Ansible role
therefore defaults to `gpu_passthrough_state=disabled`.

Preview either transition before applying:

```sh
cd ansible
ansible-playbook plays/gpu_passthrough.yml --check --diff --limit mango
ansible-playbook plays/gpu_passthrough.yml --check --diff --limit mango \
  -e gpu_passthrough_state=enabled
```

Changing driver ownership rebuilds GRUB/initramfs and requires a host reboot.
Never reboot or attach the GPU to a guest without a separate maintenance plan.
The role does not manage any VM configuration; the owning stack must add or
remove `hostpci` only after the node-side state is ready.

An apply requires `-e gpu_passthrough_confirm=mango-gpu-config`. If the separately
approved operation also requests an automatic reboot, the stronger confirmation
`mango-gpu-config-and-reboot` is required.
