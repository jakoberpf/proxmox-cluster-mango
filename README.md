# mango

Node and cluster-management repository for the standalone Proxmox VE host
`mango`. It manages the physical host and shared platform contract; application
VMs, LXCs, and their Terraform state belong in separate stack repositories.

## Scope

- Host baseline, APT sources, hostname, time sync, and persistent networking.
- Proxmox datacenter/node policy, future RBAC, resource pools, and API tokens.
- Storage attachment, ZFS maintenance policy, and Ceph health/topology contract.
- Production drift audits and explicit maintenance runbooks.
- Guest ID/ownership registry without managing guest definitions.

See [management architecture](docs/architecture.md) for the complete ownership
boundary and stack-repository contract.

## Live node

- Proxmox VE 8.4.10, standalone node `mango`.
- LAN/SSH: `192.168.8.56`, bridge `vmbr0`, gateway `192.168.8.1`.
- NetBird: `100.76.203.103`, `mango.cloudsium.home`.
- Ceph Reef: 6 OSDs, monitor `mango-new`, CephFS `lake_v1`.
- Public and cluster networks: `192.168.8.0/21`.

The observed inventory and unresolved issues are recorded in
[live state](docs/live-state.md) and the prioritized
[remediation backlog](docs/remediation.md).

The proposed Ceph S3 service is documented in [the RGW runbook](docs/s3.md).

## Commands

```sh
make setup                         # install local Ansible/lint tooling
make lint                          # YAML, shell, and whitespace checks
make syntax                        # Ansible syntax only
make audit                         # read-only live health/drift gates
make plan                          # Ansible --check --diff against mango
make apply CONFIRM=mango           # apply only after reviewing the plan
```

There is deliberately no combined deploy target. Terraform apply is disabled in
this repository; see [the Terraform boundary](terraform/README.md).

## Repository layout

```text
ansible/               Host configuration, audits, and opt-in node roles
docs/                  Architecture, live state, remediation, and runbooks
inventory/guests.yaml  VMID and ownership registry only
terraform/README.md    Terraform boundary and legacy-state notice
bin/                   Guarded local command wrappers
```

## Safety model

- Always run `make audit` and `make plan` before apply.
- The default play never upgrades packages, reloads networking, unloads KVM,
  changes GPU ownership, or mutates Ceph topology.
- Ceph OSD/pool/monitor operations, network activation, package upgrades,
  firewall/SSH changes, and reboots are separate maintenance operations.
- Do not commit vault passwords, API tokens, Terraform variables/state, SSH keys,
  NetBird identities, or decrypted secrets.
- Do not commit or push without explicit approval.

See the [reconciliation workflow](docs/reconciliation.md) for exact procedures.
