{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./modules/flatpak.nix
  ];

  ########################################
  # program modules
  ########################################

  programs = {
    firefox.enable = true;
    obs-studio.enable = true;
    gnome-disks.enable = true;
    evince.enable = true;
    # dconf.enable = true;
    niri.useNautilus = true;
    nautilus-open-any-terminal = {
      enable = true;
      terminal = "kitty";
    };
  };

  my.flatpak = {
    enable = true;
    updateWithFlake = true;
    apps = [
      "com.discordapp.Discord"
      "us.zoom.Zoom"
    ];
  };

  ########################################
  # system packages
  ########################################

  environment.systemPackages = with pkgs; [
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
    nautilus
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

    gnome-boxes # virtual machines viwer/manager
    dnsmasq # VM networking
    phodav # share files with guest VMs

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
  # virtualization setup
  ########################################

  virtualisation = {
    libvirtd = {
      enable = true;
      # # Enable TPM emulation (for Windows 11)
      # qemu = {
      #   swtpm.enable = true;
      #   ovmf.packages = [ pkgs.OVMFFull.fd ];
      # };
    };

    # Enable USB redirection (for device passthrough)
    spiceUSBRedirection.enable = true;
  };

  # Allow VM management
  users.groups.libvirtd.members = [ "david" ];
  users.groups.kvm.members = [ "david" ];

  ########################################
  # services
  ########################################

  services = {
    gnome.sushi.enable = true;
    gnome.tinysparql.enable = true;
    gvfs.enable = true;
  };

}
