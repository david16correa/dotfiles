{
  description = "My very own, very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable}: {

    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      }
      unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      }
    in

    nixosConfigurations.bjork = nixpkgs.lib.nixosSystem{

        inherit system;

        specialArgs = {
            inherit unstable;
        };

        modules = [
          ./configuration.nix
        ];

    };

    # packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;
    # packages.x86_64-linux.default = self.packages.x86_64-linux.hello;

  };
}
