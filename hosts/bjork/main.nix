{ config, lib, pkgs, inputs, unstable, static, ... }:

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
}
