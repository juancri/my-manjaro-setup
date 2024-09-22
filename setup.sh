#!/bin/bash

set -e

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
  abiword \
  aws-cli \
  bash-completion \
  bash-git-prompt \
  bind \
  cpufetch \
  deluge-gtk \
  etcher-bin \
  exfatprogs \
  expressvpn-gui-gtk \
  fastfetch \
  ffmpeg \
  git-completion \
  github-cli \
  gnome-boxes \
  gnumeric \
  google-chrome \
  gparted \
  htop \
  httpie \
  jq \
  lsd \
  manjaro-pipewire \
  mc \
  mdcat \
  meld \
  mlocate \
  nmap \
  mpv \
  neovim \
  net-tools \
  noto-fonts-emoji \
  pandoc \
  pavucontrol \
  pdftk \
  pinta \
  pkgfile \
  pop-icon-theme \
  shellcheck \
  simplescreenrecorder \
  speedtest-cli \
  subdl \
  synapse \
  texlive-fontsrecommended \
  texlive-fontsextra \
  texlive-latexextra \
  texlive-latexrecommended \
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
wget https://nodejs.org/dist/v18.16.0/node-v18.16.0-linux-x64.tar.xz
tar xf node-v18.16.0-linux-x64.tar.xz
popd

# Display seconds
echo "Displaying seconds..."
gsettings set org.gnome.desktop.interface clock-show-seconds true

# Display asterisks on sudo
echo "Displaying asterisks on sudo..."
sudo cp "${SCRIPT_DIR}/files/sudo" /etc/sudoers.d/00-asterisks

# Set default browser to Firefox
echo "Setting default browser to Firefox..."
xdg-settings set default-web-browser firefox.desktop

# Install NvChad
echo "Installing NvChad..."
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim

# Enable expressvpn
echo "Enabling ExpressVPN service..."
sudo systemctl enable expressvpn

# Disable Super+P shortcut
echo "Disabling Super+P shortcut..."
gsettings set org.gnome.mutter.keybindings switch-monitor "[]"

# Restore gnome terminal profiles
echo "Restoring GNOME Terminal profiles..."
dconf load /org/gnome/terminal/legacy/profiles:/ < "${SCRIPT_DIR}/files/gnome-terminal-profiles.dconf"

# Restore custom keybindings
echo "Restoring custom keybindings..."
dconf load '/org/gnome/settings-daemon/plugins/media-keys/' < "${SCRIPT_DIR}/files/custom-keybindings.dconf"

# Restore keyboard language keybindings
echo "Restoring keyboard language keybindings..."
dconf load '/org/gnome/desktop/wm/keybindings/' < "${SCRIPT_DIR}/files/wm-keybindings.dconf"

# Set maximize window shortcut
echo "Setting maximize window shortcut..."
gsettings set org.gnome.desktop.wm.keybindings maximize "['<Super>Up']"

# Set keyboard leyouts
echo "Setting keyboard layouts..."
gsettings set \
  org.gnome.desktop.input-sources \
  sources \
  "[('xkb', 'us'), ('xkb', 'es')]"

# Set favorite apps
echo "Setting favorite apps..."
gsettings set \
  org.gnome.shell \
  favorite-apps \
  "['org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'code.desktop', 'deluge.desktop', 'firefox.desktop']"

# Restore file manager bookmarks
echo "Restoring file manager bookmarks..."
mkdir -p ~/.config/gtk-3.0
cp "${SCRIPT_DIR}/files/bookmarks" ~/.config/gtk-3.0/bookmarks

# Set icon theme
echo "Setting icon theme..."
gsettings set \
  org.gnome.desktop.interface \
  icon-theme \
  'Pop'

# Disable night light
echo "Disabling night light..."
gsettings set \
  org.gnome.settings-daemon.plugins.color \
  night-light-enabled \
  false

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

