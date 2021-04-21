terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
      version = ">=1.14"
    }
  }
  required_version = ">= 0.14.10"
}

provider "openstack" {}