{ pkgs }:

let
  # use `jupyter lab --generate-config` to check all options
  jupyter_lab_config = pkgs.writeText "jupyter_lab_config.py" /*python*/''
    c = get_config()
    c.ExtensionApp.open_browser = False
    c.ServerApp.ip = '0.0.0.0'
    c.ServerApp.root_dir = '/home/david'
  '';

  pythonPackages = p: with p; [
    jupyter
    ipython
    numpy
    scipy
    matplotlib
    pandas
    ipykernel
    jupyterlab-vim
    jupyterlab-lsp
    python-lsp-server
  ];

  pythonEnv = pkgs.python314.withPackages pythonPackages;

  myJupyterLab = pkgs.writeShellScriptBin "myJupyterLab" ''
    exec ${pythonEnv}/bin/jupyter lab \
    --config ${jupyter_lab_config}
  '';
in
pkgs.mkShell {
  name = "jupyter";

  packages = [
    pythonEnv
    myJupyterLab
  ];

  shellHook = /*bash*/''
    export JUPYTER_CONFIG_DIR="$HOME/.dotfiles/shells/jupyter/.jupyter"
    export JUPYTER_DATA_DIR="$JUPYTER_CONFIG_DIR/data"
    export JUPYTER_RUNTIME_DIR="$JUPYTER_CONFIG_DIR/runtime"

    mkdir -p \
      "$JUPYTER_CONFIG_DIR" \
      "$JUPYTER_DATA_DIR" \
      "$JUPYTER_RUNTIME_DIR"

    # set DEBUG before `nix develop /path/to/shell#jupyter to avoid executing the jupyter server directly
    if ! [[ -n $DEBUG ]]; then 
      exec myJupyterLab
    fi
  '';
}
