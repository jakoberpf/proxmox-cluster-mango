# Agent Instructions

## Scope

- Manage only the `mango` physical node and shared Proxmox platform contract.
- Do not manage VM/LXC definitions or application configuration here.
- Record guest ownership and VMIDs in `inventory/guests.yaml`.

## Production safety

- Connect as `root@192.168.8.56` with `.ssh/automation`.
- Read live state before proposing or applying changes.
- Run `make audit` and `make plan` before `make apply CONFIRM=mango`.
- Never reload networking, upgrade packages, reboot, or change GPU ownership without a separate reviewed operation.
- Never mutate Ceph OSDs, pools, CRUSH, monitors, or PGs through the default play.
- Never stop, restart, destroy, or detach guests without explicit approval.
- Do not commit or push unless asked.

## Commands

| Task | Command |
| --- | --- |
| Lint | `make lint` |
| Syntax | `make syntax` |
| Read-only audit | `make audit` |
| Preview | `make plan` |
| Apply reviewed plan | `make apply CONFIRM=mango` |

## Repository conventions

- Run Ansible from `ansible/`; inventory host and limit are both `mango`.
- Use `apply_patch` for repository edits and preserve unrelated dirty changes.
- Keep secrets out of output and Git: `.ssh/`, vault material, tokens, tfvars, and state.
- Keep Ceph lifecycle automation audit-only; destructive work belongs in explicit runbooks.
- Terraform workload deployment belongs in separate stack repositories.

## References

| Need | File |
| --- | --- |
| Ownership boundary | `docs/architecture.md` |
| Verified node inventory | `docs/live-state.md` |
| Prioritized work | `docs/remediation.md` |
| Safe workflow | `docs/reconciliation.md` |
| GPU state | `docs/gpu-passthrough.md` |
