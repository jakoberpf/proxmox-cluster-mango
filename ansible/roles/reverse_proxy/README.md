# reverse_proxy

nginx reverse proxy on the mango host. Terminates TLS for
`gitlab.cloudsium.de` on `192.168.8.56:443` with a Let's Encrypt certificate
issued through the Cloudflare DNS-01 challenge, and proxies to the GitLab
instance at `http://10.42.1.100:80` (`proxy_upstream`). Plain HTTP on port 80
redirects to HTTPS when `proxy_http_redirect` is enabled.

The role reuses the certbot installation and the scoped Cloudflare DNS-01
credentials at `/etc/letsencrypt/cloudflare.ini` installed by the `ceph_rgw`
daemon phase; it does not manage or print the token. Certificate renewal runs
through `certbot.timer`; the deploy hook
`/etc/letsencrypt/renewal-hooks/deploy/reverse-proxy.sh` reloads nginx only
when the proxy certificate lineage was renewed.

## Gating

The play is gated. Preview first:

```sh
make proxy-plan
```

After review, apply with the confirmation token:

```sh
PROXY_CONFIRM=mango-proxy ./bin/ansible.sh proxy-apply
```

or directly from `ansible/`:

```sh
ansible-playbook plays/proxy.yml --diff --limit mango \
  -e mango_proxy_confirm=mango-proxy
```

## DNS cutover

Pointing `gitlab.cloudsium.de` at `192.168.8.56` is a separate, deferred
migration step and is intentionally not part of this role. Before the cutover
the proxy can be smoke-tested with:

```sh
curl --resolve gitlab.cloudsium.de:443:192.168.8.56 https://gitlab.cloudsium.de/
```
