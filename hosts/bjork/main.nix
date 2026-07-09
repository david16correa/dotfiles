{ config, lib, pkgs, unstable, static, inputs, ... }:

{
  imports = [
    ./hardware.nix
    ./configuration.nix

    ./software/core.nix
    ./software/apps.nix
    ./software/unstable.nix

    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  # # Installation patches:
  # boot.loader.systemd-boot.enable = lib.mkForce true;
  # boot.lanzaboote.enable = lib.mkForce false;

  networking.hostName = "bjork";
  system.stateVersion = "26.05"; # do not change this, unless you know what you're doing
}
