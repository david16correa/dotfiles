{ config, lib, pkgs, inputs, ... }:

{
  ########################################
  # program modules
  ########################################

  programs = {
    firefox.enable = true;
    obs-studio.enable = true;
    zoom-us.enable = true;
    # gnome programs
    gnome-disks.enable = true;
    evince.enable = true;
    nautilus-open-any-terminal = {
      enable = true;
      terminal = "kitty";
    };
  };

  ########################################
  # system packages
  ########################################

  environment.systemPackages = with pkgs; [
    pdftk
    maestral
    maestral-gui
    texliveFull
    pavucontrol
    pwvucontrol
    easyeffects
    libreoffice-fresh
    gcolor3
    gimp
    brave
    zotero
    prismlauncher
    protonplus
    nemo-with-extensions
    nemo-preview
    nemo-emblems
    nemo-python
    nemo-fileroller
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default
    # gnome apps
    gnome-boxes
    baobab # disk usage analyzer
    decibels # audio player
    loupe # image viewer
    nautilus # files
    showtime # video player
  ];

  ########################################
  # services
  ########################################

  services = {
    # gnome.core-apps.enable = true;
    gvfs.enable = true;
    gnome.tinysparql.enable = true;
    gnome.sushi.enable = true;
  };

}
