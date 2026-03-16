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
    pavucontrol
    pwvucontrol
    easyeffects
    # lsp-plugins
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
    spotifyd = {
      enable = true;
      settings.global.zeroconf_port = 2020;
    };
  };

  ########################################
  # firewall
  ########################################

  networking.firewall = {
    # spotifyd
    allowedTCPPorts = [ 2020 ];
    allowedUDPPorts = [ 5353 ];
  };

}
