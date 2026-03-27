/*
pendientes:
- [ ] configurar fprint solo para noctalia
- [ ] configurar swayidle, o echar a andar el widget de Keep Awake en noctalia
*/

{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    lazyvim = {
      url = "github:pfassina/lazyvim-nix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = { self, nixpkgs, home-manager, nix-index-database, ... } @ inputs:

  let
    system = "x86_64-linux";

    unstable = import inputs.nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  in
  {
    nixosConfigurations.bjork = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = { inherit inputs unstable; };

        modules = [
          { nixpkgs.config.allowUnfree = true; }

          ./nix/configuration.nix

          ./nix/system/core.nix
          ./nix/system/extra.nix
          ./nix/system/apps.nix
          ./nix/system/unstable.nix

          # inputs.nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen5

          nix-index-database.nixosModules.default {
            programs.nix-index-database.comma.enable = true;
          }

          home-manager.nixosModules.home-manager {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "nixnew";
              extraSpecialArgs = { inherit inputs unstable; };
              users.david = import ./nix/home/home.nix;
            };
          }
        ];
    };
  };
}
