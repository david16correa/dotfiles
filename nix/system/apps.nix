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
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
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
    dbus.packages = with pkgs;[
      nemo-preview
    ];
  };

}
