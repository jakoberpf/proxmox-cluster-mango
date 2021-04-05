resource "random_password" "users" {
  count            = 6
  length           = 16
  special          = true
  override_special = "_%@"
}
