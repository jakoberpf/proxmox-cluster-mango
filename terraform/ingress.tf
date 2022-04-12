module "development_ingress" {
  source  = "jakoberpf/gateway-ingress/erpf"
  version = "0.0.5"

  providers = {
    cloudflare = cloudflare
    remote     = remote.gateway1
  }

  domains = [
    "development.proxmox.erpf.de"
  ]
  host = "10.147.19.60"
  port = 8006

  cloudflare_email   = var.cloudflare_email
  cloudflare_zone_id = var.cloudflare_zone_id
  cloudflare_token   = var.cloudflare_token
}
