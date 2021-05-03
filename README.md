# development-machine


before running terraform

tf import openstack_identity_role_v3.admin <admin-role-id>


ansible localhost -m include_role -a name=octavia_certs --extra-vars "octavia_cert_client_password=testing"