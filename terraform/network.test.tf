# resource "openstack_networking_network_v2" "test" {
#   admin_state_up          = true
#   description             = ""
#   dns_domain              = ""
#   availability_zone_hints = []
#   external                = false
#   name                    = "test"
# #   port_security_enabled   = true
#   qos_policy_id           = ""
#   region                  = "RegionOne"
#   # segments {
#   #     network_type   = "flat"
#   #     physical_network = "extnet"
#   # }
#   shared                  = false
#   tags                    = []
# }

# resource "openstack_networking_subnet_v2" "test-subnet" {
#   allocation_pool {
#     end   = "192.168.222.254"
#     start = "192.168.222.2"
#   }
#   cidr              = "192.168.222.0/24"
#   description       = ""
#   dns_nameservers   = ["1.1.1.1","8.8.8.8"]
#   enable_dhcp       = true
#   gateway_ip        = "192.168.222.1"
#   # no_gateway        = false # Can't be present of gateway_ip is set
#   # host_routes {}
#   ip_version        = 4
#   # ipv6_address_mode = ""
#   # ipv6_ra_mode      = ""
#   name              = "test-subnet"
#   network_id        = "${openstack_networking_network_v2.test.id}"
#   region            = "RegionOne"
#   subnetpool_id     = ""
#   tags              = []

#   depends_on = [
#     openstack_networking_network_v2.external,
#   ]
# }