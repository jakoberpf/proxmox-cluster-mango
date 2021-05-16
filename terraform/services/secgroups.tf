# resource "openstack_compute_secgroup_v2" "octavia" {
#   name        = "octavia"
#   description = "Used by Octavia amphora instance"

#   rule {
#     from_port   = -1
#     to_port     = -1
#     ip_protocol = "icmp"
#     cidr        = "0.0.0.0/0"
#   }

#   rule {
#     from_port   = -1
#     to_port     = -1
#     ip_protocol = "icmp"
#     cidr        = "0.0.0.0/0"
#   }

#   rule {
#     from_port   = -1
#     to_port     = -1
#     ip_protocol = "icmp"
#     cidr        = "0.0.0.0/0"
#   }
# }

# openstack security group create --description 'used by Octavia amphora instance' octavia
#  openstack security group rule create --protocol icmp octavia
#  openstack security group rule create --protocol tcp --dst-port 5555 --egress octavia
#  openstack security group rule create --protocol tcp --dst-port 9443 --ingress octavia