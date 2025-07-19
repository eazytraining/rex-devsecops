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

# # Attendre que le disque soit visible
# sleep 10

# Attendre que le disque apparaisse (jusqu'à 30 secondes max)
for i in {1..30}; do
  DISK=$(lsblk -dn -o NAME,MOUNTPOINT | awk '$2=="" {print $1}' | grep -v -E "xvda|nvme0n1" | head -n 1)
  if [ -n "$DISK" ]; then
    echo "Disque détecté: /dev/$DISK"
    break
  fi
  echo "Attente de l'attachement du volume EBS... ($i/30)"
  sleep 1
done

if [ -z "$DISK" ]; then
  echo "Erreur : Aucun disque supplémentaire détecté après 30 secondes."
  exit 1
fi


set -euo pipefail

LOG_FILE="/var/log/userdata-ebs-setup.log"
exec > >(tee -a "$LOG_FILE") 2>&1

echo "=== Début du script de montage EBS ==="

# Trouver le disque non monté (exclut xvda et nvme0n1 = disque racine)
DISK=$(lsblk -dn -o NAME,MOUNTPOINT | awk '$2=="" {print $1}' | grep -Ev 'xvda|nvme0n1' | head -n 1 || true)

if [ -z "$DISK" ]; then
  echo "Aucun disque non monté trouvé."
  exit 0  # Ne pas échouer, mais rien à faire
fi

DEVICE="/dev/$DISK"
MOUNT_POINT="/mnt/data"

echo "Disque détecté : $DEVICE"

# Vérifier s’il est déjà monté
if mount | grep -q "$DEVICE"; then
  echo "$DEVICE est déjà monté."
  exit 0
fi

# Vérifier le système de fichiers
if ! blkid "$DEVICE" | grep -q 'TYPE="ext4"'; then
  echo "Formatage de $DEVICE en ext4..."
  mkfs.ext4 "$DEVICE"
else
  echo "$DEVICE est déjà formaté en ext4."
fi

# Créer le point de montage
mkdir -p "$MOUNT_POINT"

# Monter le disque
echo "Montage de $DEVICE sur $MOUNT_POINT"
mount "$DEVICE" "$MOUNT_POINT"

# Obtenir l'UUID pour fstab
UUID=$(blkid -s UUID -o value "$DEVICE")

# Vérifier si l’entrée existe déjà dans /etc/fstab
if ! grep -q "$UUID" /etc/fstab; then
  echo "Ajout à /etc/fstab"
  echo "UUID=$UUID $MOUNT_POINT ext4 defaults,nofail 0 2" >> /etc/fstab
else
  echo "Entrée déjà présente dans /etc/fstab"
fi

docker run --name nginx-c -p 8010:80 -d nginx
docker run --name apache-c -p 8020:80 -d httpd

echo "=== Fin du script ==="
