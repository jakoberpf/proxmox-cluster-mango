# https://registry.terraform.io/providers/terraform-provider-openstack/openstack/latest/docs/resources/containerinfra_clustertemplate_v1
# https://docs.openstack.org/magnum/rocky/user/
# https://docs.openstack.org/mitaka/user-guide/common/cli_install_openstack_command_line_clients.html
# https://docs.openstack.org/ocata/cli-reference/magnum.html
# https://github.com/stackhpc/magnum-terraform

# resource "openstack_containerinfra_clustertemplate_v1" "erpf" {
#   name                  = "erpf-dev"
#   image                 = "fedora-atomic"
#   cluster_distro        = "fedora-atomic"
#   coe                   = "kubernetes"
#   flavor                = "m1.small"
#   master_flavor         = "m1.medium"
#   dns_nameserver        = "1.1.1.1"
#   docker_storage_driver = "devicemapper"
#   docker_volume_size    = 10
#   volume_driver         = "cinder"
#   network_driver        = "calico"
#   server_type           = "vm"
#   master_lb_enabled     = true
#   floating_ip_enabled   = false

#   labels = {
#     kube_tag                         = "1.19.1"
#     kube_dashboard_enabled           = "true"
#     prometheus_monitoring            = "true"
#     influx_grafana_dashboard_enabled = "true"
#   }
# }