locals {
  stacks = {
    gitlab = {
      pool     = "gitlab"
      vnet     = "vngitlab"
      subnet   = "10.42.1.0/24"
      storages = ["vms", "local"]
    }
    agentic-system = {
      pool     = "agentic-system"
      vnet     = "vnagent"
      subnet   = "10.42.2.0/24"
      storages = ["vms", "local", "ceph-rbd-agentic"]
    }
  }
}
