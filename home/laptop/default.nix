{ config, lib, pkgs, static, inputs, ... }:

{
  imports = [
    ../modules
    ./configuration.nix

    # inputs.scientific-fhs.nixosModules.default
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
    gpu = "amd";
    hmDirectory = toString ./.;
  };

  home = {
    username = "david";
    stateVersion = "25.11"; # do no not change this, unless you know what you're doing
  };
}
