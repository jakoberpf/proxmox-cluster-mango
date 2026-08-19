terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.111.1"
    }
  }
  backend "http" {
    address        = "https://gitlab.cloudsium.de/api/v4/projects/198/terraform/state/main"
    lock_address   = "https://gitlab.cloudsium.de/api/v4/projects/198/terraform/state/main/lock"
    unlock_address = "https://gitlab.cloudsium.de/api/v4/projects/198/terraform/state/main/lock"
    lock_method    = "POST"
    unlock_method  = "DELETE"
    retry_wait_min = 5
  }
}

provider "proxmox" {
  endpoint  = var.pve_endpoint
  api_token = "${var.pve_token_id}=${var.pve_token_secret}"
  insecure  = var.pve_insecure
}
