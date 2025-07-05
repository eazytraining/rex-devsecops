#!/bin/bash
sudo rm -rf /var/lib/dpkg/lock-frontend && sudo rm -rf /var/lib/dpkg/lock && sudo rm -rf /var/lib/apt/lists/lock && sudo rm -rf /var/cache/apt/archives/lock
sudo mkdir -p /etc/apt/keyrings/
sudo curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list

#Turn off swap
sudo swapoff -a
sudo sed -i '/swap/d' /etc/fstab
sudo mount -a
sudo ufw disable


#Installing Kubernetes tools
sudo apt update
# apt install kubelet kubeadm kubectl -y
sudo apt install -y kubeadm=1.32.1-1.1 kubelet=1.32.1-1.1 kubectl=1.32.1-1.1

#next line is getting EC2 instance IP, for kubeadm to initiate cluster
#we need to get EC2 internal IP address- default ENI is eth0
export ipaddr=`ip address|grep eth0|grep inet|awk -F ' ' '{print $2}' |awk -F '/' '{print $1}'`
export pubip=`dig +short myip.opendns.com @resolver1.opendns.com`

# the kubeadm init won't work entel remove the containerd config and restart it.
sudo rm /etc/containerd/config.toml

sudo systemctl restart containerd

sudo tee /etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

kubeadm config images pull --kubernetes-version v1.32.1