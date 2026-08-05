{ config, lib, pkgs, static, inputs, ... }:

{
  imports = [
    ../modules
    ./configuration.nix
  ];

  ########################################
  # modules
  ########################################
  programs.home-manager.enable = true;
  my.tty.enable = true;

  ########################################
  # important settings
  ########################################
  my = {
    gpu = "nvidia";
    hmProfile = builtins.baseNameOf (toString ./.);
  };

  home = {
    username = "david";
    stateVersion = "26.05"; # do no not change this, unless you know what you're doing
  };
}
