# Reconciliation workflow

## Read-only audit

```sh
make syntax
make audit
```

The audit connects only to inventory host `mango`. It fails on identity drift,
failed systemd units, an unexpected management address, Ceph FSID/quorum/OSD
drift, unclean PGs, Ceph network drift, or the wrong CephFS mount source.

## Preview host configuration

```sh
make plan
```

Review every task and diff. A network-file diff is persistent only; the role
does not reload networking. Package tasks ensure presence and never upgrade.

## Apply reviewed host configuration

```sh
make apply CONFIRM=mango
```

Do not apply when the audit fails, backups are unavailable for the affected
area, or a task would overlap an unresolved manual change.

## Separate maintenance operations

The following are never part of the default apply and require exact commands,
recovery artifacts, and post-change gates:

- network reloads or address changes;
- package upgrades and reboots;
- SSH or firewall activation;
- ZFS disk replacement or error clearing;
- any Ceph OSD, monitor, pool, CRUSH, or PG mutation;
- GPU driver ownership changes;
- guest lifecycle operations.

## Terraform state retirement

Completed on 2026-08-16. The historical state contained only retired non-guest
resources, with lineage `72e3bfdd-e86f-a490-bfc1-c0b455d886e7` and serial `117`.
State, provider lock, stale state lock, and secret variables were moved to the
private recovery directory `~/.local/state/mango/terraform-retired-20260816/`.
All archived files are mode `0600`; the directory is mode `0700`.

No remote resource deletion is required because the state represents retired
ZeroTier, Cloudflare, local-file, and remote-file objects.

The ignored decrypted and tracked encrypted ZeroTier identities were likewise
moved to `~/.local/state/mango/zerotier-retired-20260816/`. NetBird is the live
overlay and no active repository code references ZeroTier.
