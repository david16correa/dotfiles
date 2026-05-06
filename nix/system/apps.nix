{ config, lib, pkgs, inputs, ... }:

{
  ########################################
  # program modules
  ########################################

  programs = {
    firefox.enable = true;
    obs-studio.enable = true;
    # zoom-us.enable = true;
    # gnome programs
    gnome-disks.enable = true;
    evince.enable = true;
    # dconf.enable = true;
    niri.useNautilus = true;
    nautilus-open-any-terminal = {
      enable = true;
      terminal = "kitty";
    };
  };

  ########################################
  # system packages
  ########################################

  environment.systemPackages = with pkgs; [
    pdftk
    poppler-utils
    maestral
    maestral-gui
    pavucontrol
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
    prismlauncher
    protonplus
    nautilus
    gnome-console
    baobab # disk usage analyzer
    decibels # audio player
    gcolor3 # color picker
    gnome-boxes # virtual machines viwer/manager
    loupe # image viewer
    showtime # video player
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
  # extra environment variables
  ########################################

  environment.variables = {
    # GStreamer plugin path for LibreOffice Impress video support
    GST_PLUGIN_PATH = "/run/current-system/sw/lib/gstreamer-1.0/";
  };

  ########################################
  # services
  ########################################

  services = {
    # gnome.core-apps.enable = true;
    gnome.sushi.enable = true;
    gnome.tinysparql.enable = true;
    gvfs.enable = true;
    flatpak.enable = true; # docs: https://flatpak.org/setup/NixOS
  };

}
