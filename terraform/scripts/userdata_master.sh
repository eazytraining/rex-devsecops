#!/bin/bash
echo "### USERDATA MASTER ###"

set -e 

# Installer dépendances de base 
apt update && apt install -y git curl ansible apt-transport-https ca-certificates 

echo "Starting userdata" > /tmp/userdata.log

# Clone le dépôt 
rm -rf cka-stack || echo "previous folder removed"
git clone -b ubuntu-aws https://github.com/OlivierKouokam/review-cka-stack.git cka-stack 

cd cka-stack

echo "Git clone finished" >> /tmp/userdata.log

# Définir l’adresse IP PRIVEE du master automatiquement 
IP=$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4) 

KUBERNETES_VERSION=1.31  

ansible-galaxy install -r roles/requirements.yml 

# Lancer l'installation master 
ansible-playbook install_kubernetes.yml --extra-vars "kubernetes_role=control_plane kubernetes_apiserver_advertise_address=${IP} installation_method=cloud kubernetes_version='${KUBERNETES_VERSION}'"

# Installer bash-completion puis enregistrer l’auto-complétion de kubectl
sudo apt update && sudo apt -y install bash-completion \
&& kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null
echo 'source <(kubectl completion bash)' >> ~/.bashrc

mkdir -p ~/.kube
sudo cp /root/.kube/config ~/.kube/config
sudo chown $(id -u):$(id -g) ~/.kube/config

echo "###################################################"
echo "For this Stack, you will use $(ip -f inet addr show eth0 | sed -En -e 's/.*inet ([0-9.]+).*/\1/p') IP Address"
echo "You need to be root to use kubectl in $(ip -f inet addr show eth0 | sed -En -e 's/.*inet ([0-9.]+).*/\1/p') VM (run 'sudo su -' to become root and then use kubectl as you want)"
echo "###################################################"
