echo -e "[\033[33mINFO\033[0m] Installing general packages..."
relevant_packages=(
  niri
  xwayland-satellite
  polkit-kde-agent
  xdg-desktop-portal-gnome
  gnome-firmware
  wireplumber
  playerctl
  brightnessctl
  wev
  cliphist
  cava
  decibels
  adw-gtk-theme
  matugen
)
for package in ${relevant_packages[@]}; do
    sudo pacman -S --noconfirm ${package}
done

# my extensions
echo -e "[\033[33mINFO\033[0m] Installing AUR packages..."
aur_packages=(
  noctalia-shell
  vicinae-bin
  app2unit
  pwvucontrol
)
for extension in ${extensions[@]}; do
  yay -S --noconfirm ${aur_packages}
done

# # some aur packages
# echo -e "[\033[33mINFO\033[0m] Installing essential packages (AUR)..."
# aur_packages=(
#   # gdm-settings
# )
# for package in ${aur_packages[@]}; do
#     yay -S --noconfirm ${package}
# done
