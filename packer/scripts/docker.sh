#!/bin/bash
set -e  # Exit on any error
echo "Waiting for cloud-init to complete..."
sudo cloud-init status --wait || true

# Wait for any existing apt processes to finish
echo "Waiting for apt processes to finish..."
while sudo fuser /var/lib/dpkg/lock-frontend >/dev/null 2>&1; do
    echo "Waiting for other apt processes to finish..."
    sleep 5
done

# Wait for unattended-upgrades to finish
sudo systemctl stop unattended-upgrades || true
sudo killall unattended-upgrade-shutdown || true

# Fix any interrupted dpkg operations
echo "Fixing any interrupted dpkg operations..."
sudo dpkg --configure -a || true

# Clean up any stale lock files
sudo rm -f /var/lib/dpkg/lock-frontend
sudo rm -f /var/lib/dpkg/lock
sudo rm -f /var/lib/apt/lists/lock
sudo rm -f /var/cache/apt/archives/lock

# Fix broken packages
echo "Fixing broken packages..."
sudo apt-get update || true
sudo apt-get install -f -y || true

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

VERSION_STRING=5:28.3.0-1~ubuntu.22.04~jammy
# Install Docker packages
sudo apt-get install -y \
    docker-ce=$VERSION_STRING \
    docker-ce-cli=$VERSION_STRING \
    containerd.io \
    docker-buildx-plugin \
    docker-compose-plugin -y

# Start and enable Docker service
sudo systemctl start docker
sudo systemctl enable docker

# Add ubuntu user to docker group
sudo usermod -aG docker ubuntu
