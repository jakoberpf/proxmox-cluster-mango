# CephFS NFS gateway

Status: live since 2026-09-18. All phases applied (`package`, `exports`,
`daemon`). This runbook documents the gated rollout of a kernel NFS server
that re-exports the existing CephFS filesystem (`lake_v1`) so LAN clients
without a maintained CephFS client (macOS, in particular) can mount a
subtree of it over NFS.

## Architecture diagram

[`nfs-architecture.html`](nfs-architecture.html) is a self-contained,
interactive diagram of the live setup (pan/zoom, light/dark, per-topic
callout cards) — open it directly in a browser. It shows the request path
(Mac → IP allow-list → `nfs-kernel-server` → the existing CephFS kernel
mount → Ceph mon/MDS/OSDs), the root-equivalent access caveat, the actual
security boundary, the snapshot safety net, and the removed Ganesha attempt,
kept visually separate from the live path.

## Why this shape, and why not NFS-Ganesha

macOS has no maintained CephFS client (kernel or FUSE). The first version of
this gateway used NFS-Ganesha with `FSAL_CEPH` — a dedicated CephX identity
per export, talking to the Ceph cluster directly via `libcephfs`. That
design is documented for the record because the attempt surfaced real,
useful findings, but it was abandoned:

- `nfs-ganesha` 4.3-2 (the only version Debian bookworm's repo offers) has a
  genuine heap-corruption crash in its RPC dispatch path when actually
  serving traffic through `FSAL_CEPH` — reproduced twice, the second time
  within 4 seconds of starting, with no usable backtrace (no debug symbols
  in the packaged build). This is a software stability bug, not a config
  issue: the export itself was proven correct first (it served real
  `lake_v1` content correctly before crashing).
- Two real Ganesha config bugs were found and fixed along the way, kept
  here as lessons in case Ganesha is ever revisited: `Clients` must live
  inside a nested `EXPORT { CLIENT {} }` block, not directly under
  `EXPORT {}` (silently rejected otherwise, and worse, an `EXPORT`-level
  `Access_Type` with no `CLIENT` block applies to *every* client, not just
  the intended one); and `FSAL { User_Id = "..." }` must be the bare CephX
  user id, not `client.<id>` — Ganesha prepends `client.` itself, so the
  full entity name double-prefixes the keyring lookup and fails silently
  (`Unable to init Ceph handle for /`, confirmed via `strace` to be
  looking for `ceph.client.client.<id>.keyring`).

This version instead re-exports the CephFS filesystem PVE already mounts
via its own kernel client at `/mnt/pve/lake_v1` (`client.admin`, full
access), using the plain Linux kernel NFS server (`nfs-kernel-server`,
`exportfs`, `/etc/exports`) — far more mature and battle-tested than
`nfs-ganesha`, at a real cost documented below.

## The security model changed, not just the daemon

With Ganesha, each export had its own CephX identity, and Ceph's MDS itself
enforced that identity's scope — a real, Ceph-level containment boundary
independent of the NFS daemon's own config.

**That boundary is gone in this design.** Every export here is served
through the *same* already-mounted `client.admin` kernel mount PVE itself
uses. There is no per-export Ceph auth cap anymore. The only access
boundary is `/etc/exports` itself — export path, client IP list, and squash
mapping — enforced by the kernel NFS server and nothing else. A rendering
bug or an operator mistake in `/etc/exports` can no longer be caught by a
Ceph-side cap; it fails open, not closed. Treat `inventory/nfs-exports.yaml`
and the generated `/etc/exports` as the actual security boundary, and
review changes to it accordingly.

## Data-safety guarantees for `lake_v1`

What Ganesha's per-identity cap gave for free, this design gets from
process discipline instead:

1. **Provisioning only for `rw` exports, and never for the filesystem
   root.** Directory creation and `chown` only ever run for exports marked
   `access: rw` *and* whose path is not `/`. A whole-filesystem export (rw
   or ro) is never provisioned by this role — `/mnt/pve/lake_v1` already
   exists and this role never changes its ownership or mode.
2. **Path validation before any write.** The exports phase asserts every
   registry entry's path is `/` or lives under `mango_nfs_export_root`
   (`/exports` by default) with no `..` segments, *before* touching the
   filesystem. This is a policy convention enforced by Ansible now, not a
   Ceph-enforced boundary (see above) — a typo still fails the play, but
   nothing stops a deliberately malicious registry edit the way a Ceph cap
   would have.
3. **Mandatory pre-change snapshot.** Immediately before provisioning any
   `rw` export, the exports phase takes and verifies a whole-filesystem
   CephFS snapshot (`mkdir` under `lake_v1/.snap/`). If the snapshot cannot
   be created and verified, the phase refuses to proceed.
4. **No destructive operations, ever.** No task in the `ceph_nfs` role uses
   `state: absent` or `recurse: true`. Every directory operation targets
   exactly one path this phase just validated.
5. **No pool/OSD/monitor mutation.** As with every other Ceph-adjacent role
   in this repository, this gateway never touches Ceph topology.

To roll back after a bad export change, restore from the most recent
`pre-nfs-exports-<timestamp>` snapshot under `lake_v1/.snap/` before
re-running the exports phase.

## Temporary whole-filesystem browse export

`inventory/nfs-exports.yaml` ships a `browse-lake_v1` export (path `/`,
`access: rw`) so the existing folder structure inside `lake_v1` can be
browsed and organized from macOS Finder before real per-folder exports are
defined.

This export is **root-equivalent**: `all_squash` with `anonuid=0,anongid=0`
(the `root` entry in the registry's `users` list) means every request
through it is treated as root by the kernel NFS server, so it can read,
write, or delete anything in `lake_v1` regardless of pre-existing
ownership. `allowed_clients` is a single `/32` — this Mac's LAN address
(`192.168.8.137`), not the LAN subnet.

Plain NFS (`sec=sys`/AUTH_SYS, what this export uses) has no real login —
access control here is purely "does the request's source IP match the
allow-list," which is not authentication. The planned follow-up is NFSv4 +
Kerberos (`sec=krb5`) for real per-connection authentication; a
NetBird-only `allowed_clients` restriction was considered as a cheaper
interim gate but set aside for latency/throughput reasons. Until Kerberos
is in place, treat this export's access list as the actual security
boundary and keep it as narrow as possible.

Remove `browse-lake_v1` once you've identified the real folder structure
and replaced it with scoped `rw` exports for the specific subtrees you
actually want to serve — this export should not be left running any longer
than it takes to do that.

A zero-exposure alternative for the same goal: CephFS is already
kernel-mounted on mango at `/mnt/pve/lake_v1`, so
`ssh root@192.168.8.56 'find /mnt/pve/lake_v1 -maxdepth 3'` shows the same
structure without standing up any export at all.

## How "different users" works on plain NFS

AUTH_SYS trusts whatever UID/GID a client sends — there is no username or
password. Each export instead sets `all_squash` with a fixed
`anonuid`/`anongid` pinned to that export's assigned identity from
`inventory/nfs-exports.yaml`, so every request on that export is remapped
server-side to the same owner regardless of what the client claims.
Combined with a per-export client IP allow-list, this gives one export =
one identity = one folder = one set of allowed client IPs.

This is **not** a hardened security boundary: anyone who can spoof a source
IP already permitted on an export can access it. That is an accepted
trade-off for a homelab-scale gateway, not a gap to "fix" with more NFS
configuration — real per-user authentication would require NFSv4 +
Kerberos, a materially heavier operational lift.

## Service contract

- Listener: `{{ mango LAN address }}:2049` (`mango_nfs_listen_address` /
  `mango_nfs_port` in the role defaults). The daemon phase sets
  `vers3=n` in `/etc/nfs.conf`'s `[nfsd]` section, so this gateway serves
  NFSv4 only. `rpcbind` itself is left running — it was already active on
  mango before this work started, for unrelated reasons (see
  `docs/remediation.md`), and this rollout does not depend on or try to
  fix that.
- Access: LAN, same as the S3 gateway.
- Daemon: `nfs-server.service` (kernel `nfsd` + `rpc.mountd`), export table
  at `/etc/exports` (rendered, not hand-edited).
- No Ceph identity is created or managed by this role — every export uses
  the pre-existing `client.admin` kernel mount at `/mnt/pve/lake_v1`.
- Export registry: `inventory/nfs-exports.yaml` — the only place to add,
  remove, or reassign exports and users.

The PVE firewall is currently disabled cluster-wide
(`docs/live-state.md`); this rollout does not change that. NFS/2049 is
exposed on the LAN as-is, same posture as every other service on mango
today.

## Gated phases

Run the readiness audit at any time:

```sh
make nfs-audit
```

Preview one phase at a time:

```sh
make nfs-plan PHASE=package
make nfs-plan PHASE=exports
make nfs-plan PHASE=daemon
```

There is intentionally no `make nfs-apply`. After review, each phase is
applied directly with its matching confirmation token, followed by
`make audit` and `make nfs-audit` before proceeding to the next phase.

From `ansible/`, the exact form is:

```sh
ansible-playbook plays/ceph_nfs.yml --diff --limit mango \
  -e mango_nfs_phase=package \
  -e mango_nfs_confirm=mango-nfs-package
```

Replace `package` in both extra variables with the reviewed phase name. Do
not run phases together or continue while Ceph has any unclean PGs.

The phases are:

1. `package`: simulate and install exactly the currently available
   `nfs-kernel-server` candidate; refuse upgrades or removals.
2. `exports`: verify the export registry, snapshot `lake_v1`, provision
   `rw` export directories with the registry's ownership, render
   `/etc/exports`, and reload with `exportfs -ra`.
3. `daemon`: enable and start `nfs-server.service`, verify it listens on
   `2049/tcp`, re-check the PG-clean gate.

## Export registry

Replace the placeholder entry in `inventory/nfs-exports.yaml` before the
first `exports` phase apply — the phase refuses to run against it. The
registry has two lists:

- `users`: `name`/`uid`/`gid` triples used for NFS-level squash ownership.
- `exports`: an `id`, an `owner` (a stack path or `unassigned`), a `user`
  (from `users`), a `path` (must be `/` or under `mango_nfs_export_root`,
  `/exports` by default), an `access` mode (`rw`/`ro`), and
  `allowed_clients` (IPs/CIDRs).

## References

- [Architecture diagram](nfs-architecture.html) — interactive, self-contained
- [exports(5)](https://man7.org/linux/man-pages/man5/exports.5.html)
- [exportfs(8)](https://man7.org/linux/man-pages/man8/exportfs.8.html)
- [CephFS snapshots](https://docs.ceph.com/en/reef/dev/cephfs-snapshots/)
- [Ceph S3 gateway runbook](s3.md) — the sibling gateway this pattern mirrors
- [Prioritized remediation backlog](remediation.md) — the mgr `nfs` module
  crash and the pre-existing `rpcbind` this gateway does not depend on or
  attempt to fix
