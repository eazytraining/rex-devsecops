#!/bin/bash
echo "### USERDATA DOCKER ###"
# sudo apt update
# sudo apt install git python3 -y

# curl -fsSL https://get.docker.com -o get-docker.sh
# sh get-docker.sh
# sudo usermod -aG docker ubuntu
# sudo systemctl start docker
# sudo systemctl enable docker
# sudo chmod +x /usr/bin/docker
# /usr/bin/docker run -d --name eazylabs --privileged -v /var/run/docker.sock:/var/run/docker.sock -p 1993:1993 eazytraining/eazylabs:latest

echo "MY AWS EC2"

docker run --name nginx-c -p 8050:80 -d nginx
docker run --name apache-c -p 8060:80 -d httpd