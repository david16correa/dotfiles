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
        jupyterlab-vim
        jupyterlab-lsp
        python-lsp-server
      ];
  in {
    devShells = forAllSystems (pkgs: {
      default = pkgs.mkShell {
      name = "jupyter";
      packages = [(pkgs.python314.withPackages pythonPackages)];

      shellHook = ''
        export JUPYTER_CONFIG_DIR="/home/david/.dotfiles/flakes/jupyter/.jupyter"
        export JUPYTER_DATA_DIR="$JUPYTER_CONFIG_DIR/data"
        export JUPYTER_RUNTIME_DIR="$JUPYTER_CONFIG_DIR/runtime"

        mkdir -p "$JUPYTER_CONFIG_DIR" "$JUPYTER_DATA_DIR" "$JUPYTER_RUNTIME_DIR"

        exec jupyter lab --config /home/david/.dotfiles/flakes/jupyter/jupyter_lab_config.py
      '';
      };
    });
  };
}
