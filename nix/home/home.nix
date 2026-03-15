{ pkgs, unstable, inputs, ... }:

{
  imports = [
    ./lazyvim.nix
    ./theme.nix
  ];

  home = {
    stateVersion = "25.11"; # the state version is required and should stay at the version you originally installed
    # packages = with pkgs; [ ];
  };

  xdg = {
    enable = true;
    userDirs.enable = true;
    userDirs.createDirectories = true;
    configFile = {
      "fastfetch".source = ./config/fastfetch/config.jsonc;
      "kitty".source = ./config/kitty/kitty.conf;
      "oh-my-posh".source = ./config/oh-my-posh/theme.omp.json;
      "yazi" = {
        source = ./config/yazi;
        recursive = true;
      };
    };
  };
}
