#!/bin/bash

echo -e "[\033[33mINFO\033[0m] Installing stow, and setting up system configurations..."
sudo pacman -S --noconfirm stow
DOTFILES_PATH="$(cd $(dirname $0) && cd .. && pwd)"
sudo stow -t / $DOTFILES_PATH/systemConfigs

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
  dhcpcd
  bluez
  bluez-utils
  bluez-deprecated-tools
  pulseaudio-bluetooth
  bluetui
  easyeffects
  lsp-plugins
  cups
  cups-pdf
  bluez-cups
  fprintd
  fwupd
  tlp
  tlp-rdw
  tlpui
  dosfstools
  ntfsprogs
  ntfs-3g
  rsync
  keyd
  sbctl
  caligula
  ddcutil
  unrar
  ufw
  gufw
  nftables
  pacman-contrib
  reflector
  sshfs
  zerotier-one
)
for package in ${relevant_packages[@]}; do
    sudo pacman -S --noconfirm ${package}
done

echo -e "[\033[33mINFO\033[0m] Installing command line utilities..."
cli=(
  ttf-jetbrains-mono-nerd
  otf-latin-modern
  otf-latinmodern-math
  btop
  rocm-smi-lib
  nvtop
  lsd
  tree
  bat
  tmux
  vim
  neovim
  tree-sitter-cli
  ripgrep
  openssh
  yazi
  kitty
  wezterm
  zoxide
  fzf
  timeshift
  cronie
  distrobox
  docker
  dmidecode
  gum
  pdftk
  spotifyd
  trash-cli
  unrar
  wine
  wine-mono
)
for package in ${cli[@]}; do
    sudo pacman -S --noconfirm ${package}
done

echo -e "[\033[33mINFO\033[0m] Installing dev tools..."
dev_tools=(
  jdk21-openjdk
  python-virtualenv
  github-cli
)
for package in ${dev_tools[@]}; do
    sudo pacman -S --noconfirm ${package}
done

echo -e "[\033[33mINFO\033[0m] Installing desktop software..."
desktop_soft=(
  inkscape
  libreoffice-still
  obs-studio
  signal-desktop
  torbrowser-launcher
  firefox
  torbrowser-launcher
  gcolor3
  gimp
  flatpak
  baobab
  decibels
  showtime
  snapshot
  evince
  gnome-boxes
  gnome-disk-utility
  gnome-firmware
  gnome-software
  gparted
  loupe
  nautilus
  sushi
  nemo
  nemo-fileroller
  nemo-image-converter
  nemo-media-columns
  pavucontrol
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

echo -e "[\033[33mINFO\033[0m] Installing AUR packages..."
aur_packages=(
  ttf-adwaita-mono-nerd
  ttf-linux-libertine
  ttf-meslo-nerd
  ttf-ms-fonts
  brave-bin
  zotero-bin
  obsidian
  zoom
  juliaup
  maestral
  maestral-qt
  # dropbox
  # dropbox-cli
  ookla-speedtest-bin
  oh-my-posh
  apple_cursor
  thinkfan
  elecwhat-bin
  gdlauncher-bin
  minecraft-launcher
  protonplus
  ventoy-bin
  zen-browser-bin
  pwvucontrol
  paru
)
for package in ${aur_packages[@]}; do
    yay -S --noconfirm ${package}
done

echo -e "[\033[33mINFO\033[0m] Enabling bluetooth.service..."
sudo systemctl enable --now bluetooth.service

echo -e "[\033[33mINFO\033[0m] Enabling tlp.service..."
sudo systemctl enable --now tlp.service
sudo systemctl enable --now NetworkManager-dispatcher.service
sudo systemctl mask systemd-rfkill.service
sudo systemctl mask systemd-rfkill.socket

echo -e "[\033[33mINFO\033[0m] Enabling keyd.service..."
sudo systemctl enable --now keyd

echo -e "[\033[33mINFO\033[0m] Enabling thinkfan.service..."
echo "options thinkpad_acpi fan_control=1" | sudo tee /etc/modprobe.d/thinkfan.conf
sudo modprobe -r thinkpad_acpi && sudo modprobe thinkpad_acpi
sudo mkinitcpio -P
sudo systemctl enable --now thinkfan
# thinkfan sleep hook
sudo chmod +x /usr/lib/systemd/system-sleep/thinkfan

echo -e "[\033[33mINFO\033[0m] Enabling zerotier-one.service..."
sudo systemctl enable --now zerotier-one.service
