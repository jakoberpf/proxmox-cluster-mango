resource "openstack_networking_network_v2" "external" {
  admin_state_up          = true
  description             = ""
  dns_domain              = ""
  availability_zone_hints = []
  external                = true
  name                    = "external"
  # port_security_enabled   = true
  qos_policy_id           = ""
  segments {
      network_type   = "flat"
      physical_network = "physnet1"
  }
  shared                  = true
  tags                    = []
}

resource "openstack_networking_subnet_v2" "external-subnet" {
  allocation_pool {
    end   = "192.168.2.254"
    start = "192.168.2.100"
  }
  cidr              = "192.168.0.0/22" # The external network should reside in the local network, where the servers are deployed in (MAAS)
  description       = ""
  dns_nameservers   = [] # ["1.1.1.1","8.8.8.8"]
  enable_dhcp       = false
  gateway_ip        = "192.168.1.1"
  # host_routes {}
  ip_version        = 4
  # ipv6_address_mode = ""
  # ipv6_ra_mode      = ""
  name              = "external-subnet-custom"
  network_id        = openstack_networking_network_v2.external.id
  subnetpool_id     = ""
  tags              = []

  depends_on = [
    openstack_networking_network_v2.external,
  ]
}