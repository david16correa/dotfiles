{ config, lib, pkgs, inputs, ... }:
{
  ########################################
  # program modules
  ########################################
  home.packages = with pkgs; [
    devenv
    julia
  ];

  ########################################
  # common and cusotm configs
  ########################################
  my.configs = {
    # tty
    fastfetch.enable = true;
    kitty.enable = true;
    scripts.enable = true;
    starship.enable = true;
    tmux.enable = true;
    yazi.enable = true;
    zsh.enable = true;
    # de
    avatar.enable = true;
    colors.enable = true;
    niri.enable = true;
    noctalia.enable = true;
    vicinae.enable = true;
    wallpapers.enable = true;
  };

  ########################################
  # user directories and xdg configs
  ########################################
  home.homeDirectory = "/home/${config.home.username}";

  xdg = {
    enable = true;

    userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = false; # stateVersion compatibility config; new default adoption
    };

    mimeApps = {
      enable = true;
      defaultApplications = {
        # File explorer
        "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
        # Browser
        "text/html" = [ "zen-beta.desktop" ];
        "x-scheme-handler/http" = [ "zen-beta.desktop" ];
        "x-scheme-handler/https" = [ "zen-beta.desktop" ];
        # Images
        "image/png" = [ "org.gnome.Loupe.desktop" ];
        "image/jpeg" = [ "org.gnome.Loupe.desktop" ];
        "image/svg+xml" = [ "org.inkscape.Inkscape.desktop" ];
        # Documents
        "application/pdf" = [ "org.gnome.Evince.desktop" ];
      };
    };
  };

  ########################################
  # theming
  ########################################
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  dconf.settings = {
    "org/gnome/desktop/interface".text-scaling-factor = 1.15;
    "org/gnome/desktop/wm/preferences".button-layout = ":";
  };

  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    gtk4.theme = null; # stateVersion compatibility config; new default adoption
    iconTheme = {
      name = "MoreWaita";
      package = pkgs.morewaita-icon-theme;
    };
  };

  ########################################
  # session variables
  ########################################
  systemd.user.sessionVariables = {
    # for julia
    JULIA_NUM_THREADS = "auto"; # by default julia will use all threads
  };
}
