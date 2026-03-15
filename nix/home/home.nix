{ pkgs, unstable, inputs, ... }:

{
  imports = [
    ./lazyvim.nix
    ./theme.nix
  ];

  home = {
    stateVersion = "25.11"; # the state version is required and should stay at the version you originally installed
    # packages = with pkgs; [ ];
    file = {
      ".tmux.conf".source = ./config/tmux/.tmux.conf;
      ".tmux" = {
        source = ./config/tmux/.tmux;
        recursive = true;
      };
      ".backgrounds" = {
        source = ./backgrounds;
        recursive = true;
      };
      ".face".source = ./avatar/grinningCoffee.jpg;
    };
  };

  xdg = {
    enable = true;
    # /home/* directories
    userDirs.enable = true;
    userDirs.createDirectories = true;
    # my dotfiles
    configFile = {
      "fastfetch/config.jsonc".source = ./config/fastfetch/config.jsonc;
      "kitty/kitty.conf".source = ./config/kitty/kitty.conf;
      "oh-my-posh/theme.omp.json".source = ./config/oh-my-posh/theme.omp.json;
      "yazi" = {
        source = ./config/yazi;
        recursive = true;
      };
      "leovim" = {
        source = ./config/leovim;
        recursive = true;
      };
      "niri" = {
        source = ./config/niri;
        recursive = true;
      };
    };
  };
}
