#!/bin/bash

sudo apt install curl -y
curl -fsSL https://get.docker.com -o install-docker.sh
sudo sh install-docker.sh
sudo usermod -aG docker ubuntu
sudo systemctl enable docker 
sudo systemctl start docker