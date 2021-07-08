# General
variable "node_count" {
  type        = number
  description = "Number of nodes"
  default     = 3
}
# Zerotier
variable "zerotier_central_token" {
  type        = string
  description = "The API token of the zerotier API"
}
variable "zerotier_network_id" {
  type        = string
  description = "The ID of the zerotier network"
}
