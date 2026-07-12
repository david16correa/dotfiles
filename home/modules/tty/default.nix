{ lib, config, pkgs, inputs, ... }:
let
  cfg = config.my.tty;

  btopPackage = {
    none = pkgs.btop;
    amd = pkgs.btop-rocm;
    nvidia = pkgs.btop-cuda;
    intel = pkgs.btop;
  }.${config.my.gpu};
in
{
  imports = [
    ./lazyvim.nix
  ];

  options.my.tty = {
    enable = lib.mkEnableOption "enable my terminal configuration";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      zoxide.enable = true;
      lazygit.enable = true;

      scientific-fhs = {
        enable = true;
        juliaVersions = [
          { version = "1.11.6"; default = true; }
        ];
        enableNVIDIA = false;
        enableGraphical = true;  # needed for plotting, REPL graphics etc.
      };
    };
    my.nvim.enable = true;

    home.packages = with pkgs; [
      kitty
      gnome-console
      trashy
      tmux
      fastfetch
      stow
      tree
      tealdeer
      rsync
      caligula
      gcc
      gum
      gh
      compsize
      starship
      fzf
      lsd
      ripgrep
      yazi
      ripdrag
      wget
      bat
      bluetui
      ookla-speedtest
      ffmpeg
      imagemagick
      wl-clipboard
      unrar

      btopPackage
    ];

    ########################################
    # session variables
    ########################################

    systemd.user.sessionVariables = {
      # for zsh
      STARSHIP_CONFIG = "${config.xdg.configHome}/starship/config.toml";
      EDITOR = "nvim";
      # for julia
      JULIA_NUM_THREADS = "auto"; # by default julia will use all threads
    };
  };
}
