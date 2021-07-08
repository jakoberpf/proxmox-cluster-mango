# Zerotier
variable "zerotier_central_token" {
  type        = string
  description = "The API token of the zerotier API"
}
variable "zerotier_network_id" {
  type        = string
  description = "The ID of the zerotier network"
}
variable "zerotier_openstack_ip" {
  type        = string
  description = "The IP to assign to the bastion"
}
