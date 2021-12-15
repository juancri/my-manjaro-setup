#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Find fastest mirror
echo "Finding fastest mirror..."
sudo pacman-mirrors --geoip

# Update and upgrade
echo "Update and upgrade..."
sudo pacman -Syuu

# Setup pikaur
echo "Setting up pikaur..."
sudo pacman -S --needed base-devel git
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
  bind \
  cpufetch \
  deluge-gtk \
  expressvpn-gui-gtk \
  ffmpeg \
  github-cli \
  google-chrome \
  htop \
  httpie \
  jq \
  lsd \
  meld \
  nmap \
  mpv \
  neofetch \
  neovim \
  net-tools \
  pandoc \
  pavucontrol \
  pdftk \
  pinta \
  simplescreenrecorder \
  speedtest-cli \
  texlive-most \
  tldr \
  traceroute \
  visual-studio-code-bin \
  whois \
  youtube-dl \
  zoom

# Install node
echo "Installing nodejs..."
mkdir -p ~/src/node
pushd ~/src/node
wget https://nodejs.org/dist/v16.13.0/node-v16.13.0-linux-x64.tar.xz
tar xf node-v16.13.0-linux-x64.tar.xz
popd

# Display seconds
echo "Displaying seconds..."
gsettings set org.gnome.desktop.interface clock-show-seconds true

# Display asterisks on sudo
echo "Displaying asterisks on sudo..."
sudo cp "${SCRIPT_DIR}/files/sudo" /etc/sudoers.d/00-asterisks

# Install NvChad
echo "Installing NvChad"
git clone https://github.com/NvChad/NvChad ~/.config/nvim
nvim +'hi NormalFloat guibg=#1e222a' +PackerSync

# Set default browser to Google Chrome
echo "Setting default browser to Google Chrome..."
xdg-settings set default-web-browser google-chrome.desktop

# Set favorite apps
echo "Setting favorite apps..."
gsettings set org.gnome.shell favorite-apps "['google-chrome.desktop', 'org.gnome.Terminal.desktop', 'pavucontrol.desktop', 'visual-studio-code.desktop', 'org.gnome.Geary.desktop']"

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


