# Node counts
variable "node_count_mon" {
  type        = number
  description = "Number of MON nodes"
  default     = 3
}
variable "node_count_monitoring" {
  type        = number
  description = "Number of MONITORING nodes"
  default     = 1
}
variable "node_count_mgrs" {
  type        = number
  description = "Number of MGRS nodes"
  default     = 1
}
variable "node_count_osd" {
  type        = number
  description = "Number of OSD nodes"
  default     = 5
}
variable "node_count_rgws" {
  type        = number
  description = "Number of RGWS nodes"
  default     = 1
}
# Node id prefix
variable "node_prefix_mon" {
  type        = number
  description = "Prefix of MON nodes"
  default     = 2
}
variable "node_prefix_monitoring" {
  type        = number
  description = "Prefix of MONITORING nodes"
  default     = 3
}
variable "node_prefix_mgrs" {
  type        = number
  description = "Prefix of MRGS nodes"
  default     = 4
}
variable "node_prefix_osd" {
  type        = number
  description = "Prefix of OSD nodes"
  default     = 5
}
variable "node_prefix_rgws" {
  type        = number
  description = "Prefix of RGWS nodes"
  default     = 6
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
