{ pkgs }:

let
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
in
pkgs.mkShell {
  name = "jupyter";

  packages = [
    (pkgs.python314.withPackages pythonPackages)
  ];

  shellHook = /*bash*/''
  export JUPYTER_CONFIG_DIR="$HOME/.dotfiles/shells/jupyter/.jupyter"
  export JUPYTER_DATA_DIR="$JUPYTER_CONFIG_DIR/data"
  export JUPYTER_RUNTIME_DIR="$JUPYTER_CONFIG_DIR/runtime"

  mkdir -p \
    "$JUPYTER_CONFIG_DIR" \
    "$JUPYTER_DATA_DIR" \
    "$JUPYTER_RUNTIME_DIR"

  exec jupyter lab \
    --config "$HOME/.dotfiles/shells/jupyter/jupyter_lab_config.py"
  '';
}
