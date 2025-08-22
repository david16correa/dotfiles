echo -e "[\033[33mINFO\033[0m] Installing general packages..."
relevant_packages=(
  # niri
  gnome-firmware
  wireplumber
  brightnessctl
  wev
)
for package in ${relevant_packages[@]}; do
    sudo pacman -S --noconfirm ${package}
done

# # some aur packages
# echo -e "[\033[33mINFO\033[0m] Installing essential packages (AUR)..."
# aur_packages=(
#   # gdm-settings
# )
# for package in ${aur_packages[@]}; do
#     yay -S --noconfirm ${package}
# done
