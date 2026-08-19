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
- `terraform/` manages platform-level Proxmox API resources only (pools, service
  users, tokens, ACLs, SDN). Run it through `./bin/terraform.sh`; GitLab HTTP
  state, `TF_HTTP_*` auth from the environment. Workload deployment (VMs,
  applications) belongs in separate stack repositories.
- Local Terraform applies may route through an SSH tunnel
  (`ssh -fN -L 18006:127.0.0.1:8006 root@192.168.8.56`) with
  `TF_VAR_pve_endpoint=https://127.0.0.1:18006/api2/json` and
  `TF_VAR_pve_insecure=true` when direct 8006 connectivity is unreliable.

## References

| Need | File |
| --- | --- |
| Ownership boundary | `docs/architecture.md` |
| Verified node inventory | `docs/live-state.md` |
| Prioritized work | `docs/remediation.md` |
| Safe workflow | `docs/reconciliation.md` |
| GPU state | `docs/gpu-passthrough.md` |
