# Terraform boundary

This node repository does not deploy VMs, containers, or application stacks.
Terraform configurations belong in separate stack repositories and must use:

- a dedicated Proxmox resource pool;
- a dedicated `@pve` automation user and privilege-separated API token;
- least-privilege ACLs scoped to that pool and required storage;
- a remote or otherwise backed-up state backend;
- an explicit plan review before apply.

The historical local state was inspected and retired outside the repository. It
contained ZeroTier, Cloudflare, local-file, and remote-file resources, but no
live Mango VM or LXC resources. Do not run `terraform apply` here.

The Mango node repository owns the host, network, storage attachment, Ceph
health contract, Proxmox RBAC/pool bootstrap, and operational guardrails. See
[`../docs/architecture.md`](../docs/architecture.md).
