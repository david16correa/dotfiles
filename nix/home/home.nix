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
      "fastfetch/config.jsonc".source = ./config/fastfetch/config.jsonc;
      "kitty/kitty.conf".source = ./config/kitty/kitty.conf;
      "oh-my-posh/theme.omp.json".source = ./config/oh-my-posh/theme.omp.json;
      "yazi" = {
        source = ./config/yazi;
        recursive = true;
      };
    };
  };
}
