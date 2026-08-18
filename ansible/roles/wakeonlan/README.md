# Wake-on-LAN

Installs an idempotent one-shot service that arms the selected physical NIC and
records the node MAC in Proxmox. This role is opt-in and is not imported by
`plays/main.yaml`.

Preview it separately before use:

```sh
ansible-playbook plays/wakeonlan.yml --check --diff --limit mango
```

An apply additionally requires `-e wakeonlan_confirm=mango-wol`.
