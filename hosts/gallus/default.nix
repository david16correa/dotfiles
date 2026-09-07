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
    steamConsole.enable = true;
    devel = {
      enable = true;
      keyd.enable = false;
      virtualisation.enable = false;
    };
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
