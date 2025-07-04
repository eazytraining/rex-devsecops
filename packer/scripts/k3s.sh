#!/bin/bash

curl -sfL https://get.k3s.io | sh - --kubelet-arg="cgroup-driver=systemd" --write-kubeconfig-mode 644
if [ $? -ne 0 ]; then
    echo "Erreur lors de l'installation de K3s"
    exit 1
fi
echo "K3s installé avec succès"
