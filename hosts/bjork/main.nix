{ config, lib, pkgs, unstable, static, inputs, ... }:

{
  imports = [
    ./hardware.nix
    ./configuration.nix

    ./system/core.nix
    ./system/extra.nix
    ./system/apps.nix
    ./system/unstable.nix
    ./system/static.nix

    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  # # Installation patches:
  # boot.loader.systemd-boot.enable = lib.mkForce true;
  # boot.lanzaboote.enable = lib.mkForce false;
  # my.flatpak.enable = lib.mkForce false;

}
