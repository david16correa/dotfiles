{ config, lib, pkgs, static, inputs, ... }:

{
  imports = [
    ../modules
    ./theme.nix
    ./configuration.nix

    ./software/core.nix
  ];

  my.gpu = "amd";

  home = {
    username = "david";
    homeDirectory = "/home/${config.home.username}";
    stateVersion = "25.11"; # do no not change this, unless you know what you're doing
  };
}
