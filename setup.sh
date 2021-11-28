#!/bin/bash

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

# Install extra packages
echo "Installing extra packages..."
pikaur -S \
  bind \
  cpufetch \
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
sudo cp files/sudo /etc/sudoers.d/00-asterisks

# Generate SSH key
echo "Generating SSH key..."
mkdir -p ~/.ssh
ssh-keygen -f ~/.ssh/id_rsa -N ""

# Configure git
echo "Configuring git..."
git config --global init.defaultBranch master
read -p "Enter your name:" FULLNAME
read -p "Enter your email:" EMAIL
git config --global user.name "${FULLNAME}"
git config --global user.email "${EMAIL}"



