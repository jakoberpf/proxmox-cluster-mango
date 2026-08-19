# Remediation backlog

This list is ordered by data-loss and security risk. Every live change requires
its own preview and verification; none is performed by the default Ansible play.

## P0: protect data

1. Recover or replace the permanently damaged file reported by
   `zpool status -v transfer`.
2. Replace `/dev/sdd`; the single-device `transfer` pool has no redundancy and
   already reports reallocated sectors/checksum errors.
3. Restore external backups. The powered-off PBS means there is currently no
   functioning node-managed backup path for production workloads.
4. Test restores, not only backup creation.

## P1: reduce management-plane exposure

1. Create a tested PVE firewall ruleset allowing SSH/API access from the trusted
   LAN and NetBird before enabling it.
2. Confirm console/out-of-band recovery, then disable SSH password login and
   consider replacing direct root SSH with a named administrative account.
3. Add MFA for interactive PVE administration.
4. Create per-stack resource pools and privilege-separated API tokens. Proxmox
   documents that token permissions remain a subset of the backing user.
5. Verify notification delivery for SMART, ZFS, Ceph, backup, and certificate alerts.

## P1: update lifecycle

1. Restore verified backups and physical-console access.
2. Update PVE 8.4 to the latest PVE 8 packages and reboot into the new kernel.
3. Run the official PVE 8-to-9 checklist and resolve every warning.
4. Plan the PVE 9.2 / Debian 13 / Ceph Squid-or-newer migration separately.

Proxmox recommends regular updates. Its enterprise repository is the stable,
better-tested production channel; `pve-no-subscription` is usable without a
subscription but receives less-tested updates.

## P2: Ceph hygiene

The gated RGW rollout from `docs/s3.md` was applied on 2026-08-18: bootstrap
pools exported and merged to 8 PGs, 4+2 EC bucket-data pool created, RGW live
at `https://s3.mango.cloudsium.de:7480`. On 2026-08-19 the RBD pools
`k8s-gitlab` and `k8s-agentic` (8 PGs, size 3, autoscaler off) plus scoped
`client.csi-*` users were created directly, and ceph-csi-rbd was Helm-installed
into both Talos clusters (verified with a bound+mounted test PVC). Remaining:

1. Review PG utilization and autoscaler recommendations as object counts grow.
2. Treat single-node Ceph as local disk-failure protection, not node-level HA,
   and keep independent copies of important S3 data outside mango.
3. Configure RGW consumers, buckets, policies, and lifecycle rules per
   `docs/s3.md` and `inventory/s3-consumers.yaml`, then smoke-test.
4. The ceph-csi pools and CephX users are codified in the `ceph_csi` role
   (`plays/ceph_csi.yml`). Remaining: move the ceph-csi Helm values and the
   csi-rbd secrets into the stack repos' flux/ (sops), then adopt the
   imperative Helm releases into Flux.
5. The mgr `nfs` module crashes periodically (RECENT_MGR_MODULE_CRASH since
   2026-08-18); investigate or disable it if NFS is not used.

Proxmox recommends three monitors for Ceph HA. That cannot be achieved on one
physical node; additional monitors on the same node do not provide node redundancy.

## P2: configuration reconciliation

1. Bootstrap RBAC, pools, and API tokens after the stack ownership model is approved.
2. Decide whether GPU passthrough should remain disabled; then remove obsolete backup files.
3. Decide whether to install/manage a Wake-on-LAN service; the NIC itself is already armed.
4. Add a read-only generated inventory report to CI or scheduled drift monitoring.
5. Automate Dashboard certificate refresh: the Ceph Dashboard serves a manual copy
   of the PVE Let's Encrypt certificate; PVE ACME renewal does not propagate it.
6. Codify the Dashboard setup (module, RGW system user, credentials, admin
   account) in Ansible; it was enabled manually on 2026-08-18.

## References

- [Proxmox VE Administration Guide](https://pve.proxmox.com/pve-docs/pve-admin-guide.pdf)
- [Proxmox VE 9.2 release](https://www.proxmox.com/en/about/company-details/press-releases/proxmox-virtual-environment-9-2)
- [Ceph Reef placement-group guidance](https://docs.ceph.com/en/reef/rados/operations/placement-groups/)
- [OpenZFS permanent-data-error guidance](https://openzfs.github.io/openzfs-docs/msg/ZFS-8000-8A/)
