{ config, lib, pkgs, inputs, ... }:

{
  ########################################
  # dm and wm
  ########################################

  # services.xserver.enable = true;
  programs.niri = {
    enable = true;
    useNautilus = true;
  };
  services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
  };
  # services.displayManager.gdm.enable = true;

  imports = [inputs.silentSDDM.nixosModules.default];
  programs.silentSDDM = {
      enable = true;
      theme = "default";
      # settings = {
      #   backgrounds
      # };
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
    # adwaita-icon-theme
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
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.adwaita-mono
    adwaita-fonts
    lmodern
  ];

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
