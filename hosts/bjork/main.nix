{ config, lib, pkgs, unstable, static, inputs, ... }:

{
  imports = [
    ./hardware.nix
    ./configuration.nix

    ./software/core.nix
    ./software/extra.nix
    ./software/apps.nix
    ./software/unstable.nix

    inputs.lanzaboote.nixosModules.lanzaboote

    inputs.home-manager.nixosModules.home-manager {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "nixnew";
        extraSpecialArgs = { inherit inputs unstable static; };
        users.david = import ../../home/david/main.nix;
      };
    }

  ];

  # # Installation patches:
  # boot.loader.systemd-boot.enable = lib.mkForce true;
  # boot.lanzaboote.enable = lib.mkForce false;
  # my.flatpak.enable = lib.mkForce false;

}
