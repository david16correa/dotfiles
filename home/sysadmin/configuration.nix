{ config, lib, pkgs, inputs, ... }:
{
  ########################################
  # home packages
  ########################################
  home.packages = with pkgs; [
    alsa-utils
  ];

  ########################################
  # common and cusotm configs
  ########################################
  my.configs = {
    fastfetch = {
      enable = true;
      source = lib.mkForce "sysadmin/configFiles/fastfetch";
    };
    scriptsBase.enable = true;
    starship.enable = true;
    tmux.enable = true;
    yazi = {
      enable = true;
      source = lib.mkForce "sysadmin/configFiles/yazi";
    };
    zsh.enable = true;
  };

  ########################################
  # dotfiles and user directories
  ########################################
  home.homeDirectory = "/home/${config.home.username}";
}
