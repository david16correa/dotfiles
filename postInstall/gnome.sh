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
  clipboard-history
  just-perfection-desktop
  logo-menu
  quick-settings-audio-panel
  tiling-assistant
  wiggle
)
for extension in ${extensions[@]}; do
  yay -S --noconfirm gnome-shell-extension-${extension}
done
