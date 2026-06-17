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
  # system packages
  ########################################

  environment.systemPackages = with pkgs; [
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
    (catppuccin-sddm.override {
      flavor = "macchiato";
      accent = "blue";
      clockEnabled = false;
      font  = "Adwaita Sans";
      fontSize = "9";
      background = "${../home/config/backgrounds/dm16_10.jpg}";
      loginBackground = true;
      # userIcon = true;
    })
  ];


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

  ########################################
  # services
  ########################################

  services.displayManager.sddm.theme = "catppuccin-macchiato-blue";

}
