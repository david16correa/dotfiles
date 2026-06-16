{
  description = "my dotnet environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in
  {
    devShells.${system}.default = pkgs.mkShell{
      name = "dotnet";
      buildInputs = with pkgs; [
        dotnetCorePackages.dotnet_10.sdk
      ];
      shellHook = ''
        exec ${pkgs.zsh}/bin/zsh
      '';
    };
  };
}
