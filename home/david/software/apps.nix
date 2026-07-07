{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ./modules/lazyvim.nix
    ./modules/flatpak.nix
    inputs.scientific-fhs.nixosModules.default
  ];

  ########################################
  # program modules
  ########################################

  programs = {
    firefox = {
      enable = true;
      configPath = "${config.xdg.configHome}/mozilla/firefox"; # stateVersion compatibility config; new default adoption
    };

    obs-studio.enable = true;
  };

  my.flatpak = {
    enable = true;
    apps = [
      "us.zoom.Zoom"
      "com.discordapp.Discord"
      "org.DolphinEmu.dolphin-emu"
    ];
  };

  ########################################
  # home packages
  ########################################

  home.packages = with pkgs; [
    pdftk
    poppler-utils
    maestral
    maestral-gui
    easyeffects
    libreoffice-fresh
    gimp
    brave
    zotero
    spotify
    prismlauncher
    protonplus
    gnome-console
    baobab # disk usage analyzer
    decibels # audio player
    gcolor3 # color picker
    loupe # image viewer
    showtime # video player
    pavucontrol
    qbittorrent
    obsidian
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default

    # inkscape stuff
    (symlinkJoin {
      name = "inkscape-with-textext-fixed";
      paths = [
        (inkscape-with-extensions.override {
          inkscapeExtensions = [ inkscape-extensions.textext ];
        })
      ];
      buildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/inkscape \
        --prefix PYTHONPATH : ${python3.withPackages (ps: with ps; [
          pygobject3
          tk
        ])}/lib/python3.*/site-packages
        '';
    })
  ];

}
