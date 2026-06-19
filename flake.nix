{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05"; # current release
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-static.url = "github:nixos/nixpkgs/e07580dae39738e46609eaab8b154de2488133ce"; # some packages take too long to copy from cache; I want to update them sparingly

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05"; # current release
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    lazyvim = {
      url = "github:pfassina/lazyvim-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # for fhs-wrapped julia
    scientific-fhs = {
      url = "github:olynch/scientific-fhs";
      inputs.nixpkgs.follows = "nixpkgs-static";
    };
  };

  outputs = { self, nixpkgs, lanzaboote, home-manager, ... } @ inputs:
    let
      system = "x86_64-linux";

      unstable = import inputs.nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      static = import inputs.nixpkgs-static {
        inherit system;
        config.allowUnfree = true;
      };
    in
      {
      nixosConfigurations = {
        bjork = nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = { inherit inputs unstable static; };

          modules = [
            { nixpkgs.config.allowUnfree = true; }

            ./nix/bjork/configuration.nix

            ./nix/bjork/system/core.nix
            ./nix/bjork/system/extra.nix
            ./nix/bjork/system/apps.nix
            ./nix/bjork/system/unstable.nix
            ./nix/bjork/system/static.nix

            lanzaboote.nixosModules.lanzaboote

            # Lanzaboote replaces the systemd-boot module;
            # In a new install, comment out this block
            ({ pkgs, lib, ... }: {
              boot.loader.systemd-boot.enable = lib.mkForce false;
              lanzaboote = {
                enable = true;
                pkiBundle = "/var/lib/sbctl";
              };
            })

            home-manager.nixosModules.home-manager {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "nixnew";
                extraSpecialArgs = { inherit inputs unstable; };
                users.david = import ./nix/bjork/home/home.nix;
              };
            }
          ];
        };
        myIso = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };

          modules = [
            ./nix/myIso/configuration.nix
          ];
        };
      };
    };
}
