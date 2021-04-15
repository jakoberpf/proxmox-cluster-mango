resource "openstack_networking_network_v2" "test" {
  admin_state_up = true
  description    = ""
  # dns_domain              = "test.openstack.dev.jakoberpf.de."
  availability_zone_hints = []
  external                = false
  name                    = "admin"
  #   port_security_enabled   = true
  qos_policy_id = ""
  shared        = false
  tags          = []
}

resource "openstack_networking_subnet_v2" "admin_subnet" {
  cidr            = "10.0.0.0/24"
  description     = ""
  dns_nameservers = ["1.1.1.1", "8.8.8.8"]
  enable_dhcp     = true
  gateway_ip      = "10.0.0.1"
  # host_routes {}
  ip_version    = 4
  name          = "admin-subnet"
  network_id    = openstack_networking_network_v2.test.id
  subnetpool_id = ""
  tags          = []

  depends_on = [
    openstack_networking_network_v2.external,
  ]
}
