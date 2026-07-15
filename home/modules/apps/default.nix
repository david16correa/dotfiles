{ lib, config, pkgs, inputs, ... }:
let
  cfg = config.my.apps;
in
{
  imports = [
    ./flatpak.nix
  ];

  options.my.apps = {
    enable = lib.mkEnableOption "enable my apps";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      obs-studio.enable = true;
      firefox = {
        enable = true;
        configPath = "${config.xdg.configHome}/mozilla/firefox"; # stateVersion compatibility config; new default adoption
      };
    };

    my.flatpak = {
      enable = true;
      apps = [
        "us.zoom.Zoom"
        "com.discordapp.Discord"
        "org.DolphinEmu.dolphin-emu"
        "com.mojang.Minecraft"
      ];
    };

    home.packages = with pkgs; [
      easyeffects
      gimp
      brave
      zotero
      spotify
      # prismlauncher
      protonplus
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

  };
}
