{ config, lib, pkgs, inputs, unstable, ... }:
{
  imports = [
    ./theme.nix
    ./configuration.nix
    ./software/core.nix
  ];

  home = {
    username = "david";
    homeDirectory = "/home/david";
    stateVersion = "25.11"; # do no NOT change this, unless you know what you're doing
  };

}
