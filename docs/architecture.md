# Mango management architecture

## Repository boundary

| Concern | Owner |
| --- | --- |
| Physical host, OS baseline, APT sources, hostname, time sync | This repository, via Ansible |
| Proxmox datacenter/node settings, RBAC, resource pools, API-token policy | This repository |
| Host bridge and management address | This repository; activation is always a separate maintenance step |
| Storage attachment, ZFS maintenance policy, Ceph health contract | This repository |
| Ceph RGW daemon, endpoint contract, pool topology, S3 identity registry | This repository, gated phases |
| Ceph OSD creation/removal, pool deletion, recovery operations | Explicit maintenance runbooks only |
| VM/LXC lifecycle and application configuration | Separate stack repositories |
| Stack Terraform state and secrets | The owning stack repository/backend |

This is a standalone Proxmox node, not a Corosync cluster. The repository name
uses "cluster" as a management boundary, not as a claim of node-level HA.

## Stack contract

Each stack repository must receive, from this repository:

1. A dedicated Proxmox resource pool.
2. A dedicated `@pve` automation user and privilege-separated API token.
3. ACLs scoped to its resource pool and explicitly approved storage/network use.
4. A registered VMID range or explicit VMID allocation.
5. The stable provider inputs: API endpoint, node name, bridge names, and storage IDs.

Each stack repository owns its VM/LXC definitions, lifecycle, guest bootstrap,
application configuration, and Terraform state. It must never manage node
networking, Ceph topology, host packages, or another stack's resources.

## Current management flow

```text
operator
  -> make audit       read-only production drift gates
  -> make plan        Ansible --check --diff against mango only
  -> review
  -> make apply CONFIRM=mango
```

Terraform application is intentionally disabled here. The historical state is
retired and contains no live VM/LXC resources.

## Safety boundaries

- The active Ansible play never upgrades packages automatically.
- Network files are validated and persisted, but never reloaded by a handler.
- Nested virtualization is configured for future module loads; `kvm_amd` is
  never unloaded while guests may be running.
- Ceph tasks are audit-only. No `ceph-volume`, OSD, pool, or monitor mutation is
  present in the default automation. RGW preparation is a separately confirmed,
  phase-gated play.
- GPU passthrough and Wake-on-LAN remain separate opt-in plays.
