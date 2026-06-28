{ config, lib, pkgs, unstable, static, inputs, ... }:
{
  imports = [
    ./theme.nix
    ./configuration.nix
    ./software/core.nix
    ./software/apps.nix
    ./software/unstable.nix
    ./software/static.nix
  ];

  home = {
    stateVersion = "25.11"; # do no NOT change this, unless you know what you're doing
  };

}
