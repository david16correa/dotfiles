echo -e "[\033[33mINFO\033[0m] Installing firmware management software..."
relevant_packages=(
  gnome-firmware
)
for package in ${relevant_packages[@]}; do
    sudo pacman -S --noconfirm ${package}
done

# some aur packages
echo -e "[\033[33mINFO\033[0m] Installing essential packages (AUR)..."
aur_packages=(
  extension-manager
  gdm-settings
)
for package in ${aur_packages[@]}; do
    yay -S --noconfirm ${package}
done

# my extensions
echo -e "[\033[33mINFO\033[0m] Installing essential Gnome Extensions (AUR)..."
extensions=(
  blur-my-shell
  caffeine
  clipboard-indicator
  just-perfection-desktop
  quick-settings-audio-panel
  tiling-assistant
  wiggle
  appindicator
  vitals
  search-light-git
)
for extension in ${extensions[@]}; do
  yay -S --noconfirm gnome-shell-extension-${extension}
done

echo -e "[\033[33mNOTE\033[0m] Restart the Gnome shell for the extensions to appear!"

echo -e "[\033[33mNOTE\033[0m] Remember to install: removable-drive-menu, and auto-move-windows; these are not available in the AUR!"
