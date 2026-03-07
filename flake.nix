{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  # outputs = { self, nixpkgs, nixpkgs-unstable, quickshell, noctalia, ... } @ inputs:
  outputs = { self, nixpkgs, nixpkgs-unstable, ... } @ inputs:

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
        ];

    };

  };
}
