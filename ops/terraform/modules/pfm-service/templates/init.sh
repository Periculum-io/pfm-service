#!/bin/bash
echo -e "Updated font size for user consent message"
cd /home/ubuntu
echo -e "export PROXY_ADDRESS_FORWARDING=true" | sudo tee ../../etc/profile.d/myvar.sh
sudo apt-get update
sudo apt update && sudo apt upgrade -y
sudo apt install -y git
sudo apt install midori -y #TODO make admin portal non public and use ssh X11 midori to setup realms
sudo apt update && sudo apt upgrade -y
echo -e "Install Postgresql Client"
sudo apt install postgresql-client -y
sudo PGPASSWORD=${database_password} createdb ${database_name} -h ${database_hostname} -U ${database_username}
echo -e "Installing JAVA"
sudo apt install default-jdk -y
sudo apt install openjdk-11-jdk - y
sudo apt install default-jre -y
echo -e "Downloading KeyCloak"
wget https://github.com/keycloak/keycloak/releases/download/19.0.2/keycloak-19.0.2.tar.gz
tar -xvzf keycloak-19.0.2.tar.gz
sudo chmod -R a+rwx keycloak-19.0.2
cd keycloak-19.0.2
cd conf
sudo > keycloak.conf
echo -e "db=postgres\ndb-username=${database_username}\ndb-password=${database_password}\ndb-url=jdbc:postgresql://${database_hostname}/${database_name}\ndb-url-port=${database_port}\nhealth-enabled=true\nmetrics-enabled=true\nhostname-strict-back-channel=true\nhttp-enabled=true\nhttp-host=0.0.0.0\nhttp-port=8080\nhostname-url=https://${host_name}\nhostname-admin-url=https://${host_name}\nproxy=edge" | sudo tee keycloak.conf
cd ..
cd bin
./kc.sh build --db postgres
KEYCLOAK_ADMIN=${keycloak_admin_name} KEYCLOAK_ADMIN_PASSWORD=${keycloak_admin_password} ./kc.sh start &
sleep 20
sudo killall java
cd ..
cd ..
echo -e "Cloning Repository and Copying"
git clone https://${github_username}:${github_personal_access_token}@github.com/Periculum-io/periculum-keycloak-api.git
sudo chmod -R a+rwx periculum-keycloak-api
sudo cp -a periculum-keycloak-api/themes keycloak-19.0.2
cd ..
cd ..
echo -e "Creating Daemon"
cd etc/systemd/system
echo -e "[Unit]\nDescription=keycloak\nAfter=network.target\nStartLimitIntervalSec=0\n\n[Service]\nUser=ubuntu\nGroup=www-data\nWorkingDirectory=/home/ubuntu/keycloak-19.0.2/bin\nExecStart=/home/ubuntu/keycloak-19.0.2/bin/kc.sh start --proxy edge\nRestart=always\n\n[Install]\nWantedBy=multi-user.target" | sudo tee keycloak.service
echo -e "Installing nginx"
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
cd /home/ubuntu
cd ../../etc/nginx/sites-available
echo -e "Updating nginx configuration"
echo -e "upstream keycloak {\r\n\tserver 127.0.0.1:8080;\r\n}\r\n\r\nserver { \r\n\tlisten 80;\r\n\r\n\tserver_name ${host_name};\r\n\t\r\n\tproxy_set_header\t\tX-Forwarded-For\t\t\$proxy_add_x_forwarded_for;\r\n\tproxy_set_header\t\tX-Forwarded-Host\t\$host;\r\n\tproxy_set_header\t\tX-Forwarded-Proto\t\$scheme;\r\n\tproxy_buffer_size\t\t128k;\r\n\tproxy_buffers\t\t\t4 256k;\r\n\tproxy_busy_buffers_size\t\t256k;\r\n\r\n\tlocation /\r\n\t{\r\n\t\tproxy_pass http://keycloak/;\r\n\t}\r\n}" | sudo tee default
echo -e "Starting nginx and keycloak daemon service"
sudo systemctl restart nginx
sudo systemctl start keycloak
sudo systemctl enable keycloak