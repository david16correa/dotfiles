{ config, lib, pkgs, inputs, ... }:

{
  ########################################
  # program modules
  ########################################

  programs = {
    firefox.enable = true;
    obs-studio.enable = true;
    zoom-us.enable = true;
  };

  ########################################
  # system packages
  ########################################

  environment.systemPackages = with pkgs; [
    pdftk
    maestral
    maestral-gui
    texliveFull
    spotifyd
    pavucontrol
    pwvucontrol
    easyeffects
    lsp-plugins
    libreoffice-fresh
    gcolor3
    gimp
    evince
    gnome-boxes
    gparted
    brave
    zotero
    prismlauncher
    protonplus
  ]++[
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default
  ];

  ########################################
  # services
  ########################################

  services = {
  };

}
