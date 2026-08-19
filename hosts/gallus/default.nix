{ config, lib, pkgs, unstable, static, inputs, ... }:

{
  imports = [
    ../modules
    ./hardware.nix
    ./configuration.nix
  ];

  ########################################
  # modules
  ########################################

  my = {
    wm.enable = true;
    dm.enable = true;
    devel.enable = true;
    extra.enable = true;
    services.enable = true;
  };

  ########################################
  # patches
  ########################################
  boot.loader.systemd-boot.enable = lib.mkForce true;
  boot.lanzaboote.enable = lib.mkForce false;

  ########################################
  # important settings
  ########################################
  networking.hostName = "gallus";
  programs.nh.flake = "/home/david/.dotfiles";
  system.stateVersion = "26.05"; # do not change this, unless you know what you're doing
}
