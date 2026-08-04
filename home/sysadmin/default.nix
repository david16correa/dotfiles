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
    tty.enable = true;
    config = {
      fastfetch.enable = true;
      scripts.enable = true;
      starship.enable = true;
      tmux.enable = true;
      yazi.enable = true;
      zsh.enable = true;
    };
  };

  ########################################
  # important settings
  ########################################

  my.gpu = "nvidia";

  home = {
    username = "david";
    homeDirectory = "/home/${config.home.username}";
    stateVersion = "26.05"; # do no not change this, unless you know what you're doing
  };

}
