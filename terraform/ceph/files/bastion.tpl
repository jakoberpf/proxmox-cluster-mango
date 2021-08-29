#cloud-config
#install Cloudflare Tunnel and Docker resources
#follow Execution with "sudo journalctl -xef"

package_update: true
package_upgrade: true
package_reboot_if_required: true

packages:
  - nginx
  - apt-transport-https
  - ca-certificates
  - curl
  - gnupg-agent
  - software-properties-common

runcmd:
  # Setup Zerotier
  - curl -o zerotier-install.sh https://raw.githubusercontent.com/jakoberpf/zerotier-scripts/main/zerotier-installer.sh
  - chmod +x zerotier-install.sh
  - ./zerotier-install.sh
  - zerotier-cli join ${zerotier_network_id}
  # Setup Nginx
  - rm /etc/nginx/sites-enabled/default
  - systemctl restart nginx


write_files:
  - path: /var/lib/zerotier-one/identity.public
    content: |
      ${zerotier_public_key}

  - path: /var/lib/zerotier-one/identity.secret
    content: |
      ${zerotier_private_key}

  - path: /etc/nginx/nginx.conf
    content: |
      user www-data;
      worker_processes auto;
      pid /run/nginx.pid;
      include /etc/nginx/modules-enabled/*.conf;

      events {
        worker_connections 768;
        # multi_accept on;
      }

      http {

        ##
        # Basic Settings
        ##

        sendfile on;
        tcp_nopush on;
        tcp_nodelay on;
        keepalive_timeout 65;
        types_hash_max_size 2048;
        # server_tokens off;

        # server_names_hash_bucket_size 64;
        # server_name_in_redirect off;

        include /etc/nginx/mime.types;
        default_type application/octet-stream;

        ##
        # SSL Settings
        ##

        ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # Dropping SSLv3, ref: POODLE
        ssl_prefer_server_ciphers on;

        ##
        # Logging Settings
        ##

        access_log /var/log/nginx/access.log;
        error_log /var/log/nginx/error.log;

        ##
        # Gzip Settings
        ##

        gzip on;

        # gzip_vary on;
        # gzip_proxied any;
        # gzip_comp_level 6;
        # gzip_buffers 16 8k;
        # gzip_http_version 1.1;
        # gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

        ##
        # Virtual Host Configs
        ##

        include /etc/nginx/conf.d/*.conf;
        include /etc/nginx/sites-enabled/*;
      }
      include /etc/nginx/passthrough.conf;

  - path: /etc/nginx/passthrough.conf
    content: |
      ## tcp LB and SSL passthrough for backend ##
      stream {
          upstream kubernetes_api {
              server ${master1_ip}:6443 max_fails=3 fail_timeout=10s;
              server ${master2_ip}:6443 max_fails=3 fail_timeout=10s;
              server ${master3_ip}:6443 max_fails=3 fail_timeout=10s;
          }

      log_format basic '$remote_addr [$time_local] '
                      '$protocol $status $bytes_sent $bytes_received '
                      '$session_time "$upstream_addr" '
                      '"$upstream_bytes_sent" "$upstream_bytes_received" "$upstream_connect_time"';

          access_log /var/log/nginx/kubernetes_api_access.log basic;
          error_log  /var/log/nginx/kubernetes_api_error.log;

          server {
              listen 6443;
              proxy_pass kubernetes_api;
              proxy_next_upstream on;
          }
      }