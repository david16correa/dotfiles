{ config, lib, pkgs, inputs, ... }:
{
  ########################################
  # home packages
  ########################################

  home.packages = with pkgs; [
    wget
    bat
    bluetui
    trashy
    libcanberra-gtk3
    unrar
    ookla-speedtest
    cliphist
    app2unit
    ffmpeg
    imagemagick
    ripdrag
    wl-clipboard
  ];

  ########################################
  # session variables
  ########################################

  systemd.user.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "gtk3"; # https://docs.noctalia.dev/v4/getting-started/faq/#why-are-some-of-my-app-icons-missing
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "${config.home.homeDirectory}/.steam/root/compatibilitytools.d";
  };

}
