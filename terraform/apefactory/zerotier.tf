# https://registry.terraform.io/providers/zerotier/zerotier/latest/docs/resources/member
# https://registry.terraform.io/providers/zerotier/zerotier/latest/docs/resources/identity

resource "zerotier_identity" "bitbucket_runner" {}

resource "zerotier_member" "bitbucket_runner" {
  name           = "bitbucket_runner"
  member_id      = zerotier_identity.bitbucket_runner.id
  network_id     = var.zerotier_network_id
  ip_assignments = [var.zerotier_bitbucket_runner_ip]
}
