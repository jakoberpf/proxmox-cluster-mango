locals {
  stacks = {
    gitlab = {
      pool   = "gitlab"
      vnet   = "vngitlab"
      subnet = "10.42.1.0/24"
    }
    agentic-system = {
      pool   = "agentic-system"
      vnet   = "vnagent"
      subnet = "10.42.2.0/24"
    }
  }
}
