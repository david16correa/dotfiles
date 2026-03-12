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
    spotifyd
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

  services = {
    gnome.core-apps.enable = true;
    gnome.tinysparql.enable = true;
    gvfs.enable = true;
    spotifyd.enable = true;
    flatpak.package = true;
    zerotierone.enable = true;
    udisks2.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
    };
    # fprintd.enable = true; # remember to use sudo with fprint-commands!
  };

  # custom systemd services
  systemd = {
    services.keyd = {
      enable = true;
      description = "key remapping daemon";
      wantedBy = [ "sysinit.target" ];
      wants = [ "local-fs.target" ];
      after = [ "local-fs.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.keyd}/bin/keyd";
      };
    };
    user.services.polkit-gnome-authentication-agent-1 = {
      enable = true;
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
    };
  };

}
