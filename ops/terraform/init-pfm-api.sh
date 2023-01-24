#!/bin/bash
echo -e "Starting Setup Script"
cd /home/ubuntu
sudo apt-get update
sudo apt update && sudo apt upgrade -y
sudo apt install -y git
echo -e "Cloning Repository"
git clone https://${github_username}:${github_personal_access_token}@github.com/Periculum-io/periculum-pfm.git
sudo chmod -R a+rwx periculum-pfm
sudo chmod -R a+rwx /usr/share
wget https://packages.microsoft.com/config/ubuntu/21.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
sudo apt-get update
sudo apt-get install -y apt-transport-https
sudo apt-get update
sudo apt-get install -y dotnet-sdk-5.0
cd periculum-pfm
cd admin-dashboard
cd backend
cd pfm.api
sudo dotnet build
echo -e "Creating daemon service"
cd /home/ubuntu
cd ..
cd ..
cd etc/systemd/system
echo -e "[Unit]\nDescription=pfm-api\nAfter=network.target\nStartLimitIntervalSec=0\n\n[Service]\nUser=ubuntu\nGroup=www-data\nWorkingDirectory=/home/ubuntu/periculum-pfm/admin-dashboard/backend/Pfm.Api\nExecStart=/usr/bin/dotnet /home/ubuntu/periculum-pfm/admin-dashboard/backend/Pfm.Api/bin/Debug/net5.0/PfmApi.dll --urls=http://localhost:8000\nRestart=always\n\n[Install]\nWantedBy=multi-user.target" | sudo tee pfm-api.service
echo -e "Installing nginx"
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
cd /home/ubuntu
cd ../../etc/nginx/sites-available
echo -e "Updating nginx configuration"
echo -e "upstream htmltopdfapi {\n\tserver 127.0.0.1:8000;\n}\n\nserver {\n\trewrite ^/htmltopdf(/.*)$ \$1 last;\n\tlisten 80;\n\tserver_name pdfprocessing.periculum-models.link;\n\tlocation / {\n\t\tproxy_pass http://htmltopdfapi;\n\t}\n}" | sudo tee default
echo -e "Starting nginx and html-to-pdf-api daemon service"
sudo systemctl restart nginx
sudo systemctl start html-to-pdf-api
sudo systemctl enable html-to-pdf-api
echo -e "Finished"