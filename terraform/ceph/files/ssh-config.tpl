Host *
  ForwardAgent yes
  StrictHostKeyChecking no
  
Host dev-machine
  Hostname ssh.openstack.dev.erpf.de
  User jakoberpf
  IdentityFile /Users/jakoberpf/Projects/jakoberpf/erpf-bootstrap/.ssh/automation_rsa
  
Host bastion
  Hostname 192.168.2.196
  User ubuntu
  ProxyJump dev-machine
  IdentityFile /Users/jakoberpf/Projects/jakoberpf/erpf-bootstrap/.ssh/automation_rsa

%{ for index, id in mon-id ~}
Host ${id}
  Hostname ${mon-ip[index]}
  User ${mon-user}
  ProxyJump dev-machine
  IdentityFile /Users/jakoberpf/Projects/jakoberpf/erpf-bootstrap/.ssh/automation_rsa
%{ endfor ~}