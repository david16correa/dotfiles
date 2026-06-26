{ config, lib, pkgs, unstable, static, inputs, ... }:

{
  imports = [
    ./hardware.nix
    ./configuration.nix

    ./software/core.nix
    ./software/extra.nix
    ./software/apps.nix
    ./software/unstable.nix
    ./software/static.nix

    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  # # Installation patches:
  # boot.loader.systemd-boot.enable = lib.mkForce true;
  # boot.lanzaboote.enable = lib.mkForce false;
  # my.flatpak.enable = lib.mkForce false;

}
