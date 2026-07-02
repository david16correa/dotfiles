{ config, lib, pkgs, unstable, static, inputs, ... }:

{
  imports = [
    ./theme.nix
    ./configuration.nix
    ./software/core.nix
    ./software/extra.nix
    ./software/apps.nix
    ./software/unstable.nix
    ./software/static.nix
  ];

  home = {
    username = "david";
    homeDirectory = "/home/${config.home.username}";
    stateVersion = "25.11"; # do no not change this, unless you know what you're doing
  };
}
