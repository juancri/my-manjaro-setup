#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Sync time
echo "Syncing time..."
sudo timedatectl set-ntp true

# Find fastest mirror
echo "Finding fastest mirror..."
sudo pacman-mirrors --geoip

# Update and upgrade
echo "Update and upgrade..."
sudo pacman -Syuu

# Setup pikaur
echo "Setting up pikaur..."
sudo pacman -S --needed base-devel
mkdir -p ~/src
cd ~/src
git clone https://aur.archlinux.org/pikaur.git
cd pikaur
makepkg -fsri
cd ~

# Don't compress packages
echo "Setting pacman to don't compress packages..."
sudo sed -i "s/PKGEXT='.pkg.tar.zst'/PKGEXT='.pkg.tar'/" /etc/makepkg.conf

# Import key for express vpn
echo "Importing key for express vpn..."
wget -O /tmp/expressvpn.asc https://www.expressvpn.com/expressvpn_release_public_key_0xAFF2A1415F6A3A38.asc
gpg --import /tmp/expressvpn.asc

# Install extra packages
echo "Installing extra packages..."
pikaur -S \
  aws-cli \
  bash-completion \
  bash-git-prompt \
  bind \
  cpufetch \
  deluge-gtk \
  etcher-bin \
  exfatprogs \
  expressvpn-gui-gtk \
  ffmpeg \
  flameshot \
  git-completion \
  github-cli \
  gnome-boxes \
  google-chrome \
  gparted \
  htop \
  httpie \
  jq \
  lsd \
  mc \
  meld \
  mlocate \
  nmap \
  mpv \
  neofetch \
  neovim \
  net-tools \
  noto-fonts-emoji \
  pandoc \
  pavucontrol \
  pdftk \
  pinta \
  shellcheck \
  simplescreenrecorder \
  speedtest-cli \
  synapse \
  texlive-most \
  tldr \
  traceroute \
  visual-studio-code-bin \
  whois \
  yt-dlp \
  zoom

# Update pkgfile database
echo "Updating pkgfile database..."
sudo pkgfile -u

# Install node
echo "Installing nodejs..."
mkdir -p ~/src/node
pushd ~/src/node
wget https://nodejs.org/dist/v16.17.0/node-v18.15.0-linux-x64.tar.xz
tar xf node-v18.15.0-linux-x64.tar.xz
popd

# Display asterisks on sudo
echo "Displaying asterisks on sudo..."
sudo cp "${SCRIPT_DIR}/files/sudo" /etc/sudoers.d/00-asterisks

# Set default browser to Google Chrome
echo "Setting default browser to Google Chrome..."
xdg-settings set default-web-browser google-chrome.desktop

# Disable super key to open menu
echo "Disabling super key as the shortcut to open the main menu..."
gsettings set com.solus-project.brisk-menu hot-key ''

# Install neovim plugins
curl -sLf https://spacevim.org/install.sh | bash

# Enable expressvpn
echo "Enabling ExpressVPN service..."
sudo systemctl enable expressvpn

# Set up bash
echo "Setting up bash..."
cp "${SCRIPT_DIR}/files/bashrc" ~/.bashrc

# Generate SSH key
echo "Generating SSH key..."
mkdir -p ~/.ssh
ssh-keygen -f ~/.ssh/id_rsa -N ""

# Configure git
echo "Configuring git..."
git config --global init.defaultBranch master
read -p "Enter your name: " FULLNAME
read -p "Enter your email: " EMAIL
git config --global user.name "${FULLNAME}"
git config --global user.email "${EMAIL}"

# Display public key
echo "This is your public key. You can register it on GitHub."
cat ~/.ssh/id_rsa.pub

