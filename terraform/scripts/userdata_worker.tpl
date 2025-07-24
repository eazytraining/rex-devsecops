#!/bin/bash
echo "### USERDATA WORKER ###"

set -e 
 
# Installer dépendances 
apt update && apt install -y git curl ansible 
 
# Récupérer le code 
rm -rf cka-stack || echo "previous folder removed"
git clone -b ubuntu-aws https://github.com/OlivierKouokam/review-cka-stack.git cka-stack 

cd cka-stack
 
ansible-galaxy install -r roles/requirements.yml 
 
ansible-playbook install_kubernetes.yml --extra-vars "kubernetes_role=node kubernetes_apiserver_advertise_address=${MASTER_IP} kubernetes_version='${KUBERNETES_VERSION}' kubernetes_join_command='kubeadm join ${MASTER_IP}:6443 --ignore-preflight-errors=all --token=783bde.3f89s0fje9f38fhf --discovery-token-unsafe-skip-ca-verification'"

# Installer bash-completion puis enregistrer l’auto-complétion de kubectl
sudo apt update && sudo apt -y install bash-completion \
&& kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null
echo 'source <(kubectl completion bash)' >> ~/.bashrc

echo "###################################################"
echo "For this Stack, you will use $(ip -f inet addr show eth0 | sed -En -e 's/.*inet ([0-9.]+).*/\1/p') IP Address"
echo "You need to be root to use kubectl in $(ip -f inet addr show eth0 | sed -En -e 's/.*inet ([0-9.]+).*/\1/p') VM (run 'sudo su -' to become root and then use kubectl as you want)"
echo "###################################################"