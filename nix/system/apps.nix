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
    maestral
    maestral-gui
    pavucontrol
    easyeffects
    libreoffice-fresh
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav
    gimp
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
    # (texliveSmall.withPackages (ps: with ps; [
    #   physics
    # ]))
    texliveFull
    brave
    zotero
    prismlauncher
    protonplus
    # nemo-with-extensions
    nautilus
    gnome-console
    baobab # disk usage analyzer
    decibels # audio player
    gcolor3 # color picker
    gnome-boxes # virtual machines viwer/manager
    loupe # image viewer
    showtime # video player
    inputs.zen-browser.packages."${pkgs.stdenv.hostPlatform.system}".default
  ];

  ########################################
  # extra environment variables
  ########################################

  environment.variables = {
    GST_PLUGIN_SYSTEM_PATH_1_0 =
      "${pkgs.gst_all_1.gstreamer}/lib/gstreamer-1.0:" +
      "${pkgs.gst_all_1.gst-plugins-base}/lib/gstreamer-1.0:" +
      "${pkgs.gst_all_1.gst-plugins-good}/lib/gstreamer-1.0:" +
      "${pkgs.gst_all_1.gst-plugins-bad}/lib/gstreamer-1.0:" +
      "${pkgs.gst_all_1.gst-plugins-ugly}/lib/gstreamer-1.0:" +
      "${pkgs.gst_all_1.gst-libav}/lib/gstreamer-1.0";
  };

  ########################################
  # services
  ########################################

  services = {
    # gnome.core-apps.enable = true;
    gnome.sushi.enable = true;
    gnome.tinysparql.enable = true;
    gvfs.enable = true;
  };

}
