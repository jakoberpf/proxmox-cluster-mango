# Observed live state

Last verified: 2026-08-17. Re-run `make audit` before relying on this snapshot.

## Platform

- Standalone node `mango`; no `/etc/pve/corosync.conf`.
- Proxmox VE 8.4.10 on Debian 12 with kernel `6.8.12-13-pve`.
- 32 logical CPUs, 251 GiB RAM, no host swap.
- Management/LAN: `vmbr0` on `enp5s0`, `192.168.8.56/21`, gateway `192.168.8.1`.
- NetBird: `100.76.203.103`, also providing the host resolver configuration.
- An nginx reverse proxy (`reverse_proxy` role, `plays/proxy.yml`) terminates TLS for
  `gitlab.cloudsium.de` on `192.168.8.56:443` and proxies to `http://10.42.1.100:80`.
- `enp9s0` is disconnected; `wlp3s0` is unused.

## Proxmox objects

- 10 QEMU VMs and 3 LXCs; 5 VMs and all 3 LXCs were running during inspection.
- No Proxmox resource pools, HA resources, or replication jobs.
- Only `root@pam` exists; there are no groups, custom roles, ACLs, or API tokens.
- The PVE firewall is disabled and has no cluster/node rules.
- One enabled backup job targets powered-off PBS storage and VM 201.
- PBS storages `pbs-mango` and `pbs-pineapple` are configured but unavailable.

## Storage

- `rpool`: mirrored 500 GB SATA SSDs, healthy, ZFS root.
- `vms`: single Intel NVMe device, healthy, approximately 54% allocated.
- `transfer`: single 10 TB HDD, 6.71 TiB used, with one permanent file error.
- `/dev/sdd` backing `transfer` reports 8 reallocated sectors and 2 checksum errors.
- ZFS trim and scrub run monthly through `/etc/cron.d/zfsutils-linux`.

## Ceph

- Reef 18.2.4, FSID `438cbb6e-5e6e-42b5-b098-40980ad1ea4f`.
- One monitor (`mango-new`), one manager, one MDS, one RGW, and six 16 TB HDD OSDs.
- Public and cluster networks: `192.168.8.0/21`.
- CephFS `lake_v1` is mounted from `192.168.8.56:/`.
- Approximately 32 TiB logical data and 49 TiB raw used of 87 TiB.
- RGW serves `https://s3.mango.cloudsium.de:7480` (see `docs/s3.md`); seven RGW
  pools at 8 PGs each, bucket data in a 4+2 EC pool. The former PG-count
  warning is resolved; Ceph reports HEALTH_OK.
- This topology tolerates selected OSD failures but not failure of the physical node.

## Host security and lifecycle

- SSH permits direct root login and password authentication; two authorized keys exist.
- SSH, PVE API/UI, rpcbind, NetBird, Ceph, and the Ceph Dashboard (8443) listen
  on the host network. The Dashboard serves the same Let's Encrypt certificate
  as the PVE UI and manages the RGW at `https://mango.cloudsium.de:8443`.
- 192 package upgrades were pending, including PVE 8 updates and a newer kernel.
- PVE 9.2 is the current major release; a major upgrade requires a separate project.
- The PVE UI serves a Let's Encrypt certificate for `mango.cloudsium.de`
  (PVE-managed ACME via Cloudflare DNS-01, auto-renewed).
- SMART and ZFS services are active, but alert delivery has not been proven.
- GPU passthrough is currently disabled: `amdgpu` and `snd_hda_intel` own the RX 6600 XT, and no VM has `hostpci`.
- The NIC reports Wake-on-LAN mode `g`; no active `wol.service` is installed.

## Workload observations handed to stack owners

- LXCs 105–107 are the three Pi-hole instances.
- Recent logs contain memory-cgroup OOM kills for Pi-hole FTL and one NetBird process.
- These resource/application changes belong in the future Pi-hole stack repository.
