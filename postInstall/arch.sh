#!/bin/bash

echo -e "[\033[33mINFO\033[0m] Installing system packages..."
relevant_packages=(
  git
  lazygit
  zsh
  fastfetch
  less
  man-db
  tealdeer
  which
  dhcp
  bluez
  bluez-utils
  bluez-deprecated-tools
  pulseaudio-bluetooth
  easyeffects
  lsp-plugins
  cups
  cups-pdf
  bluez-cups
  fprintd
  fwupd
  tlp
  tlp-rdw
  dosfstools
  ntfsprogs
  ntfs-3g
  rsync
  keyd
  # sshfs
)
for package in ${relevant_packages[@]}; do
    sudo pacman -S --noconfirm ${package}
done

echo -e "[\033[33mINFO\033[0m] Installing command line utilities..."
cli=(
  ttf-jetbrains-mono-nerd
  btop
  nvtop
  lsd
  tree
  bat
  tmux
  vim
  neovim
  ripgrep
  stow
  openssh
  yazi
  kitty
  wezterm
  zoxide
  fzf
  timeshift
  cronie
)
for package in ${cli[@]}; do
    sudo pacman -S --noconfirm ${package}
done

echo -e "[\033[33mINFO\033[0m] Installing dev tools..."
dev_tools=(
  # pyenv
  python-virtualenv
  # jdk-openjdk
  github-cli
  # marksman
)
for package in ${dev_tools[@]}; do
    sudo pacman -S --noconfirm ${package}
done

echo -e "[\033[33mINFO\033[0m] Installing desktop software..."
desktop_soft=(
  inkscape
  obs-studio
  signal-desktop
  torbrowser-launcher
  firefox
  gcolor3
  gimp
  flatpak
)
for package in ${desktop_soft[@]}; do
    sudo pacman -S --noconfirm ${package}
done

echo -e "[\033[33mINFO\033[0m] Installing LaTeX dependencies..."
latex_deps=(
  texlive
  zathura
  zathura-pdf-mupdf
)
for package in ${latex_deps[@]}; do
    sudo pacman -S --noconfirm ${package}
done

echo -e "[\033[33mINFO\033[0m] Installing yay..."
mkdir /tmp/yay
git clone https://aur.archlinux.org/yay.git /tmp/yay
cd /tmp/yay
makepkg -si

echo -e "[\033[33mINFO\033[0m] Installing and enabling ZeroTier..."
sudo pacman -S zerotier-one
sudo systemctl enable zerotier-one.service
sudo systemctl start zerotier-one.service

echo -e "[\033[33mINFO\033[0m] Installing AUR packages..."
aur_packages=(
  brave-bin
  onlyoffice-bin
  zotero-bin
  obsidian
  spotify
  zoom
  juliaup
  dropbox
  dropbox-cli
  ookla-speedtest-bin
  oh-my-posh
  apple_cursor
  thinkfan
)
for package in ${aur_packages[@]}; do
    yay -S --noconfirm ${package}
done

configsPath="$(cd $(dirname $0) && pwd)/defaultConfigs"

echo -e "[\033[33mINFO\033[0m] Enabling bluetooth daemon..."
sudo systemctl enable bluetooth.service
sudo systemctl start bluetooth.service

echo -e "[\033[33mINFO\033[0m] Configuring and enabling TLP..."
sudo cp $configsPath/tlp.conf /etc/tlp.conf
sudo systemctl enable --now tlp.service
sudo systemctl enable --now NetworkManager-dispatcher.service
sudo systemctl mask systemd-rfkill.service
sudo systemctl mask systemd-rfkill.socket

echo -e "[\033[33mINFO\033[0m] Configuring and enabling keyd..."
sudo mkdir -p /etc/keyd
sudo cp $configsPath/keyd.conf /etc/keyd/default.conf
sudo systemctl enable --now keyd

echo -e "[\033[33mINFO\033[0m] Configuring and enabling Thinkfan..."
sudo cp $configsPath/thinkfan.conf /etc/thinkfan.conf
echo "options thinkpad_acpi fan_control=1" | sudo tee /etc/modprobe.d/thinkfan.conf
sudo modprobe -r thinkpad_acpi && sudo modprobe thinkpad_acpi
sudo mkinitcpio -P
sudo systemctl enable --now thinkfan
# thinkfan sleep hook
sudo cp $configsPath/thinkfan.hook /usr/lib/systemd/system-sleep/thinkfan
sudo chmod +x /usr/lib/systemd/system-sleep/thinkfan
