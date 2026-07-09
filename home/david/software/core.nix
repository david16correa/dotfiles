{ config, lib, pkgs, inputs, ... }:
{
  ########################################
  # program modules
  ########################################

  programs = {
    home-manager.enable = true;

    scientific-fhs = {
      enable = true;
      juliaVersions = [
        { version = "1.11.6"; default = true; }
      ];
      enableNVIDIA = false;
      enableGraphical = true;  # needed for plotting, REPL graphics etc.
    };
  };

  ########################################
  # my modules
  ########################################

  my = {
    terminal.enable = true;
    desktop.enable = true;
    apps.enable = true;
    office.enable = true;
  };

  ########################################
  # session variables
  ########################################

  systemd.user.sessionVariables = {
    # for zsh
    JULIA_NUM_THREADS = "auto"; # by default julia will use all threads
  };
}
