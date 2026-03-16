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
    oh-my-posh
    wget
    fzf
    lsd
    bat
    # alsa-utils
    bluetui
    trashy
    libcanberra-gtk3
    unrar
    ripgrep
    jdk21_headless
    ookla-speedtest
    cliphist
    app2unit
    # nodejs_24
  ]++[(
    catppuccin-sddm.override {
      flavor = "macchiato";
      accent = "blue";
      clockEnabled = false;
      font  = "Adwaita Sans";
      fontSize = "9";
      background = "${../home/backgrounds/dm16_10.jpg}";
      loginBackground = true;
    }
  )];

  ########################################
  # systme fonts
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

  services = {
    gnome.core-apps.enable = true;
    gnome.tinysparql.enable = true;
    gvfs.enable = true;
    # flatpak.package = true;
    #
    displayManager.sddm = {
        theme = "catppuccin-macchiato-blue";
    };
  };

}
