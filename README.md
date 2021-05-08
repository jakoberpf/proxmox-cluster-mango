# development-machine
This repository is composed of some ansible playbooks and terraform to boostrap and setup an all in one deployment of openstack and ceph. The order of execution is ??

## Configurations

## Runbook

### Ansible
ansible localhost -m include_role -a name=octavia_certs --extra-vars "octavia_cert_client_password=testing"
### Terraform
Before running any terraform, the init and setup ansible playbook must be successfully run to have a working openstack and ceph deployment ready. Because we want to manage some admin ressources we also need to import some terraform ressources first. For this you need to login into the web dashboard or use the openstack cli to retrieve the ids of the admin role and user.

```
terraform import openstack_identity_role_v3.admin <admin-role-id>
terraform import openstack_identity_user_v3.admin <admin-user-id>
terraform import openstack_identity_project_v3.service <service-project-id>
```
## Troubleshooting
alias sshb="ssh -J $BASTION_HOST@$BASTION_IP"
curl -H "Host: test.openstack.dev.jakoberpf.de" http://192.168.2.200