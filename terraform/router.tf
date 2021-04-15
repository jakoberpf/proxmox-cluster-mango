resource "openstack_networking_router_v2" "dev" {
  admin_state_up          = true
  availability_zone_hints = []
  description             = "This network is for the development cluster"
  enable_snat             = true
  external_network_id     = openstack_networking_network_v2.external.id
  name                    = "development-router"
  tags = []
}
