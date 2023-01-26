#!/bin/bash
echo -e "Starting Setup Script"
cd /home/ubuntu
sudo apt-get update
sudo apt update && sudo apt upgrade -y
sudo apt install -y git
echo -e "Cloning Repository"
git clone https://${github_username}:${github_personal_access_token}@github.com/Periculum-io/periculum-pfm.git
sudo chmod -R a+rwx periculum-pfm
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt install python3.10 -y
sudo apt install python3-pip -y
echo -e "Creating Credentials"
echo -e "${access_key},${access_key_secret},${secret_name}" | sudo tee credentials.csv
sudo chmod a+rwx credentials.csv
cd periculum-pfm
cd pfm-api
echo -e "Need to Install Local Modules"
pip3 install -e .
cd shared_logic
pip3 install -e .
cd ..
cd flask-api
pip3 install -r requirements.txt
pip3 install gunicorn
pip3 install greenlet
pip3 install eventlet
pip3 install gevent
echo -e "Creating daemon service"
cd /home/ubuntu
cd ..
cd ..
cd etc/systemd/system
echo -e "[Unit]\nDescription=pfm-flask-api\nAfter=network.target\nStartLimitIntervalSec=0\n\n[Service]\nUser=ubuntu\nGroup=www-data\nWorkingDirectory=/home/ubuntu/periculum-pfm/pfm-api/flask-api\nExecStart=/usr/local/bin/gunicorn -b localhost:8000 --chdir /home/ubuntu/periculum-pfm/pfm-api/flask-api app:app\nRestart=always\n\n[Install]\nWantedBy=multi-user.target" | sudo tee pfm-api.service
echo -e "Installing nginx"
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
cd /home/ubuntu
cd ../../etc/nginx/sites-available
echo -e "Updating nginx configuration"
echo -e "upstream pfmapi {\n\tserver 127.0.0.1:8000;\n}\n\nserver { \n\tlisten 80;\n\tclient_max_body_size 15M;\n\tserver_name pdfprocessing.periculum-models.link;\n\tlocation / {\n\t\tproxy_pass http://pdfparserapi;\n\t}\n}" | sudo tee default
echo -e "Starting nginx and pdf-parser-api daemon service"
sudo systemctl restart nginx
sudo systemctl start pfm-api
sudo systemctl enable pfm-api
echo "Finished"