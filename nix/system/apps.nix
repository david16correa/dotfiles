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
    # dconf.enable = true;
  };

  ########################################
  # system packages
  ########################################

  environment.systemPackages = with pkgs; [
    pdftk
    maestral
    maestral-gui
    texliveSmall
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
    ffmpegthumbnailer
    poppler
    gnome-epub-thumbnailer
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default
    # gnome apps
    gnome-boxes
    baobab # disk usage analyzer
    decibels # audio player
    loupe # image viewer
    showtime # video player
  ];

  ########################################
  # services
  ########################################

  services = {
    # gnome.core-apps.enable = true;
    # gnome.sushi.enable = true;
    # gnome.tinysparql.enable = true;
    gvfs.enable = true;
  };

}
