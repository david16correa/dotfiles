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

    inputs.home-manager.nixosModules.home-manager {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "nixnew";
        extraSpecialArgs = { inherit inputs unstable; };
        users.david = import ./home/home.nix;
      };
    }

  ];

  # # Installation patches:
  # boot.loader.systemd-boot.enable = lib.mkForce true;
  # boot.lanzaboote.enable = lib.mkForce false;
  # my.flatpak.enable = lib.mkForce false;

}
