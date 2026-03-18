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
    # jdk21_headless
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
    )
    (texliveMedium.withPackages (
        ps: with ps; [
          dvisvgm dvipng # for preview and export as html
          wrapfig amsmath ulem hyperref capt-of
          fullpage physics
          #(setq org-latex-compiler "lualatex")
          #(setq org-preview-latex-default-process 'dvisvgm)
    ]))
  ];


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
    # flatpak.package = true;
    displayManager.sddm = {
        theme = "catppuccin-macchiato-blue";
    };
  };

}
