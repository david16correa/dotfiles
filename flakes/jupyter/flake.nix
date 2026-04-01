{
  description = "my jupyter environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
  let
    forAllSystems = function:
      nixpkgs.lib.genAttrs ["x86_64-linux" "aarch64-darwin"]
      (system: function nixpkgs.legacyPackages.${system});
    pythonPackages = p: with p; [
        numpy
        scipy
        matplotlib
        pandas
        jupyter
      ];
  in {
    devShells = forAllSystems (pkgs: {
      default = pkgs.mkShell {
        name = "jupyter";
        packages = [(pkgs.python314.withPackages pythonPackages)];
      shellHook = ''
        exec ${pkgs.jupyter}/bin/jupyter notebook
      '';
      };
    });
  };
}
