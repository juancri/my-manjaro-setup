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

# Install extra packages
echo "Installing extra packages..."
pikaur -S \
  bash-completion \
  bash-git-prompt \
  bind \
  git-completion \
  github-cli \
  htop \
  httpie \
  jq \
  lsd \
  mc \
  mlocate \
  neovim \
  net-tools \
  shellcheck \
  synapse \
  tldr \
  traceroute \
  visual-studio-code-bin \
  whois

# Update pkgfile database
echo "Updating pkgfile database..."
sudo pkgfile -u

# Install node
echo "Installing nodejs..."
mkdir -p ~/src/node
pushd ~/src/node
wget https://nodejs.org/dist/v18.16.0/node-v18.16.0-linux-x64.tar.xz
tar xf node-v18.16.0-linux-x64.tar.xz
popd

# Display asterisks on sudo
echo "Displaying asterisks on sudo..."
sudo cp "${SCRIPT_DIR}/files/sudo" /etc/sudoers.d/00-asterisks

# Disable super key to open menu
echo "Disabling super key as the shortcut to open the main menu..."
gsettings set com.solus-project.brisk-menu hot-key ''

# Change current user shell to bash
echo "Changing current user shell to bash..."
sudo chsh -s /bin/bash "$USER"

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
