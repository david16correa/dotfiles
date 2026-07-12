{ config, lib, pkgs, static, inputs, ... }:

{
  imports = [
    ../modules
    ./theme.nix
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

  my.gpu = "amd";

  home = {
    username = "david";
    homeDirectory = "/home/${config.home.username}";
    stateVersion = "25.11"; # do no not change this, unless you know what you're doing
  };

}
