variable "pve_endpoint" {
  description = "Proxmox API endpoint. Uses the LE-covered FQDN so TLS verifies."
  type        = string
  default     = "https://mango.cloudsium.de:8006/api2/json"
}

variable "pve_insecure" {
  description = "Skip TLS verification. Only for SSH-tunnel endpoints (127.0.0.1)."
  type        = bool
  default     = false
}

variable "pve_token_id" {
  description = "Proxmox API token ID (user@realm!name) for platform automation."
  type        = string
}

variable "pve_token_secret" {
  description = "Proxmox API token secret for platform automation."
  type        = string
  sensitive   = true
}
