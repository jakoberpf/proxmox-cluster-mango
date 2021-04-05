sudo apt install git make nano htop curl net-tools
# (https://dev.to/rahedmir/how-to-use-timeshift-from-command-line-in-linux-1l9b)
# (https://github.com/teejee2008/timeshift)
sudo apt-get install timeshift
sudo timeshift --snapshot-device /dev/sdX
sudo timeshift --btrfs
sudo btrfs quota enable /

sudo timeshift --create --comments "Clean Install"

sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw enable

sudo apt-get install vino

curl -s https://install.zerotier.com | sudo bash
sudo zerotier-cli join <id>

sudo netstat -tulpn

sudo timeshift --create --comments "Zerotier Setup"

# jakoberpf@development-machine:~$ sudo netstat -tulpn
# Active Internet connections (only servers)
# Proto Recv-Q Send-Q Local Address           Foreign Address         State       PID/Program name    
# tcp        0      0 192.168.0.197:51171     0.0.0.0:*               LISTEN      9244/zerotier-one   
# tcp        0      0 192.168.0.197:51172     0.0.0.0:*               LISTEN      9244/zerotier-one   
# tcp        0      0 192.168.0.197:9993      0.0.0.0:*               LISTEN      9244/zerotier-one   
# tcp        0      0 127.0.0.1:9993          0.0.0.0:*               LISTEN      9244/zerotier-one   
# tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      1018/systemd-resolv 
# tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      3660/sshd: /usr/sbi 
# tcp        0      0 127.0.0.1:631           0.0.0.0:*               LISTEN      1062/cupsd          
# tcp6       0      0 ::1:9993                :::*                    LISTEN      9244/zerotier-one   
# tcp6       0      0 :::22                   :::*                    LISTEN      3660/sshd: /usr/sbi 
# tcp6       0      0 ::1:631                 :::*                    LISTEN      1062/cupsd          
# udp        0      0 0.0.0.0:40239           0.0.0.0:*                           1055/avahi-daemon:  
# udp        0      0 192.168.0.197:51171     0.0.0.0:*                           9244/zerotier-one   
# udp        0      0 192.168.0.197:51172     0.0.0.0:*                           9244/zerotier-one   
# udp        0      0 127.0.0.53:53           0.0.0.0:*                           1018/systemd-resolv 
# udp        0      0 0.0.0.0:631             0.0.0.0:*                           1141/cups-browsed   
# udp        0      0 0.0.0.0:5353            0.0.0.0:*                           1055/avahi-daemon:  
# udp        0      0 192.168.0.197:9993      0.0.0.0:*                           9244/zerotier-one   
# udp6       0      0 :::54257                :::*                                1055/avahi-daemon:  
# udp6       0      0 :::5353                 :::*                                1055/avahi-daemon:  

# https://docs.openstack.org/devstack/latest/
# setup local.conf
# ./stack.sh

# OR

# https://microstack.run/docs/single-node
# sudo snap install microstack --beta --devmode
# sudo microstack init --auto --control
# sudo snap get microstack config.credentials.keystone-password

# (https://docs.openstack.org/kolla-ansible/latest/user/quickstart.html)

sudo apt install python3-dev python3-venv libffi-dev gcc libssl-dev git
python3 -m venv $HOME/kolla-openstack
source $HOME/kolla-openstack/bin/activate
pip install -U pip
pip install 'ansible<3.0'

cat << EOF > $HOME/ansible.cfg
 [defaults]
host_key_checking=False
pipelining=True
forks=100
EOF

pip install kolla-ansible
sudo mkdir /etc/kolla
sudo chown $USER:$USER /etc/kolla
cp $HOME/kolla-openstack/share/kolla-ansible/etc_examples/kolla/* /etc/kolla/
cp $HOME/kolla-openstack/share/kolla-ansible/ansible/inventory/all-in-one .

sudo apt install lvm2
sudo pvcreate -f /dev/nvme0n1p3 
sudo pvs
sudo vgcreate -f cinder-volumes /dev/nvme0n1p3
sudo vgs

kolla-genpwd

# Setpu globals.yaml
source $HOME/kolla-openstack/bin/activate
kolla-ansible -i all-in-one bootstrap-servers
kolla-ansible -i all-in-one prechecks
kolla-ansible -i all-in-one deploy
kolla-ansible -i all-in-one post-deploy
kolla-ansible -i all-in-one check


# (https://docs.openstack.org/mitaka/config-reference/firewalls-default-ports.html)
sudo ufw allow http       #
sudo ufw allow https      #
sudo ufw allow 873/tcp    # Rsync Endpoint
sudo ufw allow 5000/tcp   # Identity service public endpoint
sudo ufw allow 8776/tcp   #
sudo ufw allow 8774/tcp   #
sudo ufw allow 8386/tcp   #
sudo ufw allow 35357/tcp  #
sudo ufw allow 9292/tcp   #
sudo ufw allow 9696/tcp   #
sudo ufw allow 8004/tcp   #
sudo ufw allow 8777/tcp   #

# https://www.cloudqubes.com/hands-on/linux/setting-up-an-nginx-reverse-proxy-for-openstack/
sudo apt-get install nginx