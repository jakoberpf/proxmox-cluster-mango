resource "openstack_networking_router_v2" "test_router" {
  admin_state_up          = true
  availability_zone_hints = []
  description             = ""
  enable_snat             = true
  external_network_id     = openstack_networking_network_v2.external.id
  name                    = "admin-router"
  tags = []

  depends_on = [
    openstack_networking_network_v2.external,
  ]
}

resource "openstack_networking_router_interface_v2" "test-router_interface_test" {
  router_id = openstack_networking_router_v2.test_router.id
  subnet_id = openstack_networking_subnet_v2.admin_subnet.id

  depends_on = [
    openstack_networking_router_v2.test_router,
    openstack_networking_subnet_v2.admin_subnet,
  ]
}
