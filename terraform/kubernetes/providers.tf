terraform {
  required_version = ">= 1.0.0"
  required_providers {
    proxmox = {
      source = "telmate/proxmox"
      # version = "<version tag>"
    }
    zerotier = {
      source = "zerotier/zerotier"
    }
  }
}

provider "proxmox" {
  # https://github.com/Telmate/terraform-provider-proxmox/blob/master/docs/index.md
  pm_api_url = "https://10.147.19.60:8006/api2/json"
  pm_tls_insecure = true
  pm_user = "terraform@pve"
}

provider "zerotier" {}