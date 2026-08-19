output "stack_api_tokens" {
  description = "Per-stack Proxmox API tokens (full user@realm!name=secret form) for the stack repositories' CI."
  value = {
    for key, token in proxmox_virtual_environment_user_token.stack :
    key => token.value
  }
  sensitive = true
}
