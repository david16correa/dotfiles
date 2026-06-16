{
  description = "my LaTeX environment";

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
      name = "latex";
      buildInputs = with pkgs; [
        texliveFull
      ];
      shellHook = ''
        exec ${pkgs.zsh}/bin/zsh
      '';
    };
  };
}
