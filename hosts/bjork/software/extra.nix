{ config, lib, pkgs, inputs, ... }:

{
  ########################################
  # system fonts
  ########################################

  fonts = {
    enableDefaultPackages = true;

    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.adwaita-mono
      adwaita-fonts
      lmodern
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji-blob-bin
      liberation_ttf
      aileron
      inter
      eb-garamond
      cabin
      corefonts
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
        monospace = [ "Noto Sans Mono" ];
        emoji = [ "Blobmoji" ];
      };
    };
  };
}
