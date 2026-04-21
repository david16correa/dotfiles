{ config, lib, pkgs, inputs, ... }:

{
  ########################################
  # program modules
  ########################################

  programs = {
    firefox.enable = true;
    obs-studio.enable = true;
    # zoom-us.enable = true;
    # gnome programs
    gnome-disks.enable = true;
    evince.enable = true;
    # dconf.enable = true;
    niri.useNautilus = true;
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
    pavucontrol
    easyeffects
    libreoffice-fresh
    gimp
    (inkscape-with-extensions.override {
      inkscapeExtensions = [ inkscape-extensions.textext ];
    })
    texliveSmall
    brave
    zotero
    prismlauncher
    protonplus
    # nemo-with-extensions
    nautilus
    gnome-console
    baobab # disk usage analyzer
    decibels # audio player
    gcolor3 # color picker
    gnome-boxes # virtual machines viwer/manager
    loupe # image viewer
    showtime # video player
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default
  ];

  ########################################
  # services
  ########################################

  services = {
    # gnome.core-apps.enable = true;
    gnome.sushi.enable = true;
    gnome.tinysparql.enable = true;
    gvfs.enable = true;
  };

}
