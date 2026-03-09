{ config, lib, pkgs, inputs, ... }:

{
  ########################################
  # dm and wm
  ########################################

  # services.xserver.enable = true;

  services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "catppuccin-macchiato-blue";
  };

  programs.niri = {
    enable = true;
    useNautilus = true;
  };

  ########################################
  # program modules
  ########################################

  # programs.zsh.enable = true;
  # programs.firefox.enable = true;
  # programs.zoxide.enable = true;
  # programs.niri.useNautilus = true;
  # programs.lazygit.enable = true;
  # programs.obs-studio.enable = true;
  # programs.zoom-us.enable = true;

  programs = {
    zsh.enable = true;
    firefox.enable = true;
    zoxide.enable = true;
    lazygit.enable = true;
    obs-studio.enable = true;
    zoom-us.enable = true;
    dconf.enable = true;
    git = {
      enable = true;
      config = {
        init.defaultBranch = "main";
        url."https://github.com/".insteadOf = [
          "gh:"
          "github:"
        ];
        user = {
          name = "David Correa";
          email = "david.correa.msc@gmail.com";
        };
      };
    };
    # gnome-disks.enable = true;
  };

  ########################################
  # system packages
  ########################################

  environment.systemPackages = with pkgs; [
    vim
    tmux
    fastfetch
    oh-my-posh
    wget
    stow
    fzf
    btop-rocm
    lsd
    tree
    bat
    tealdeer
    which
    bluetui
    rsync
    caligula
    xwayland-satellite
    trashy
    glibc
    gcc
    keyd
    gum
    killall
    libcanberra-gtk3
    caligula
    unrar
    tree-sitter
    ripgrep
    dmidecode
    pdftk
    jdk21_headless
    gh
    maestral
    maestral-gui
    ookla-speedtest
    polkit_gnome
    playerctl
    brightnessctl
    cliphist
    app2unit
    texliveFull
  ]++[
    pavucontrol
    pwvucontrol
    easyeffects
    libreoffice-fresh
    gcolor3
    gimp
    evince
    gnome-boxes
    gparted
    brave
    zotero
    prismlauncher
    protonplus
  ]++[(
    catppuccin-sddm.override {
      flavor = "macchiato";
      accent = "blue";
      clockEnabled = false;
      font  = "Adwaita Sans";
      # font  = "Noto Sans";
      fontSize = "9";
      background = "${./home/backgrounds/dm16_10.jpg}";
      loginBackground = true;
    }
  )];

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

  # services.gnome.sushi.enable = true;
  services.gnome.core-apps.enable = true;
  services.gnome.tinysparql.enable = true;
  services.gvfs.enable = true;

  services.spotifyd.enable = true;

  services.flatpak.package = true;
}
