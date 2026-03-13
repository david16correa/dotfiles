/*
pendientes:
- [ ] configurar fprint solo para noctalia
*/

{
  description = "My NixOS configuration";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nixos-hardware, ... } @ inputs:

  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
    unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };
  in
  {
    nixosConfigurations.bjork = nixpkgs.lib.nixosSystem{
        inherit system;

        specialArgs = {
            inherit unstable inputs;
        };

        modules = [
          ./nix/configuration.nix

          ./nix/pkgs/core.nix
          ./nix/pkgs/extra.nix
          ./nix/pkgs/apps.nix
          ./nix/pkgs/unstable.nix

          # nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen5

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.david = import ./nix/home/home.nix;
          }
        ];

    };

  };
}
