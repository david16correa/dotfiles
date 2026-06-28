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

    # LibreOffice and GStreamer plugin stack for Impress video support
    libreoffice-fresh
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav

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
    dolphin-emu
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
        --prefix PYTHONPATH : ${
        python3.withPackages (ps: with ps; [
        pygobject3
        tk
        ])
        }/lib/python3.*/site-packages
        '';
    })
  ];

  ########################################
  # extra session variables
  ########################################

  systemd.user.sessionVariables = {
    GST_PLUGIN_PATH = "${pkgs.gst_all_1.gstreamer}/lib/gstreamer-1.0"; # GStreamer plugin path for LibreOffice Impress video support
    QT_QPA_PLATFORMTHEME = "gtk3"; # https://docs.noctalia.dev/v4/getting-started/faq/#why-are-some-of-my-app-icons-missing
  };

}
