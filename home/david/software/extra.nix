{ config, lib, pkgs, inputs, ... }:
{
  ########################################
  # program modules
  ########################################

  programs = {
    zoxide.enable = true;
    lazygit.enable = true;
  };

  ########################################
  # home packages
  ########################################

  home.packages = with pkgs; [
    starship
    wget
    fzf
    lsd
    bat
    bluetui
    trashy
    libcanberra-gtk3
    unrar
    ripgrep
    ookla-speedtest
    cliphist
    app2unit
    ffmpeg
    imagemagick
    ripdrag
    wl-clipboard
  ];

}
