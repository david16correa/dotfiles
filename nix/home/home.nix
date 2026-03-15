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
  };
}
