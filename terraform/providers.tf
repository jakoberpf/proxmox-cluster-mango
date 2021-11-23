terraform {
  required_version = ">= 1.0.0"
  required_providers {
    zerotier = {
      source = "zerotier/zerotier"
    }
    proxmox = {
      source = "telmate/proxmox"
      # version = "<version tag>"
    }
  }
}

provider "zerotier" {}

provider "proxmox" {
  # https://github.com/Telmate/terraform-provider-proxmox/blob/master/docs/index.md
  pm_api_url = "https://10.147.19.60:8006/api2/json"
}