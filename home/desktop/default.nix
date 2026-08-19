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
  my = {
    de.enable = true;
    tty.enable = true;
    apps.enable = true;
    office.enable = true;
    services.enable = true;
  };

  ########################################
  # important settings
  ########################################
  my = {
    gpu = "nvidia";
    hmDirectory = toString ./.;
  };

  home = {
    username = "david";
    stateVersion = "26.05"; # do no not change this, unless you know what you're doing
  };
}
