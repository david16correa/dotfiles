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

  outputs = { self, nixpkgs, nixpkgs-unstable, nixpkgs-static, ... } @ inputs:
  let
    system = "x86_64-linux";

    setupExtraPkgs = extraPkgs : import extraPkgs {
      inherit system;
      config.allowUnfree = true;
    };

    unstable = setupExtraPkgs nixpkgs-unstable;
    static = setupExtraPkgs nixpkgs-static;
  in {
    nixosConfigurations = {
      bjork = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = { inherit inputs unstable static; };

        modules = [
          { nixpkgs.config.allowUnfree = true; }

          ./hosts/bjork/main.nix
        ];
      };

      myIso = nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = { inherit inputs; };

        modules = [
          ./hosts/myIso/configuration.nix
        ];
      };
    };
  };
}
