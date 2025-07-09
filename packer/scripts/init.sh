#!/bin/bash

# init.sh - Script d'initialisation pour l'image Ubuntu 20.04 LTS
echo "Script Started: $(date)"
sudo apt-get update
sudo apt-get install -y git curl unzip wget tree
