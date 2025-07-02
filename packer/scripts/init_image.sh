#!/bin/bash
ENABLE_ZSH=true

# Vérifier si l'installation est demandée
if [ "$ENABLE_ZSH" != "true" ]; then
  echo "ZSH ne sera pas installé (ENABLE_ZSH n'est pas 'true')"
  exit 0
fi

echo "Script Started: $(date)"

# 1. Installer les paquets
echo "Installation de zsh et git..."
sudo apt-get update
sudo apt-get install -y zsh git curl 

# 2. Définir zsh comme shell par défaut
echo "Configuration de zsh pour l'utilisateur ubuntu..."
sudo chsh -s /bin/zsh ubuntu

# 3. Installer Oh My ZSH
echo "Installation de Oh My ZSH..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# 4. Installer les plugins
echo "Installation des plugins..."
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# 5. Configurer .zshrc
echo "Configuration du fichier .zshrc..."
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="agnoster"/' ~/.zshrc
echo 'plugins=(git zsh-syntax-highlighting)' >> ~/.zshrc

echo "Installation terminée !"
echo "Pour utiliser zsh, déconnectez-vous et reconnectez-vous."