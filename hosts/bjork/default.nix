{ config, lib, pkgs, unstable, static, inputs, ... }:

{
  imports = [
    ../modules
    ./hardware.nix
    ./configuration.nix
    ./unstable.nix
  ];

  ########################################
  # modules
  ########################################

  my = {
    wm.enable = true;
    dm.enable = true;
    devel.enable = true;
    services = {
      enable = true;
      thinkpad.enable = true;
    };
  };

  ########################################
  # patches
  ########################################

  # # Installation:
  # boot.loader.systemd-boot.enable = lib.mkForce true;
  # boot.lanzaboote.enable = lib.mkForce false;

  ########################################
  # important settings
  ########################################

  networking.hostName = "bjork";
  programs.nh.flake = "/home/david/.dotfiles";
  system.stateVersion = "26.05"; # do not change this, unless you know what you're doing
}
