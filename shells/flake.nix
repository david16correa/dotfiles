{
  description = "my dev shells";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs, ... }:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    devShells.${system} = {
      jupyter = import ./jupyter/main.nix { inherit pkgs; };
      dotnet  = import ./dotnet/main.nix { inherit pkgs; };
    };
  };
}
