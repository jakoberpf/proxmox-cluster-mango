variable "authorized_keys" {
  type        = string
  description = ""
}
variable "cloudflare_email" {
  type        = string
  description = ""
}

variable "cloudflare_zone_id" {
  type        = string
  description = ""
}

variable "cloudflare_api_key" {
  type        = string
  description = ""
}

variable "cloudflare_token" {
  type        = string
  description = ""
}

variable "cloudflare_account_id" {
  type        = string
  description = ""
}

variable "proxmox_terraform_user" {
  type        = string
  description = ""
}

variable "proxmox_terraform_password" {
  type        = string
  description = ""
}

variable "proxmox_terraform_host" {
  type        = string
  description = ""
}

variable "zerotier_central_token" {
  type        = string
  description = "The API token of the zerotier API"
}

variable "zerotier_network_id_development" {
  type        = string
  description = "The zerotier network id of the development network"
}

variable "zerotier_network_id" {
  type        = string
  description = "The ID of the zerotier network"
}
variable "zerotier_proxmox_ip" {
  type        = string
  description = "The IP to assign to the bastion"
}
