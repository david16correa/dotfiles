{ lib, config, pkgs, inputs, ... }:
let
  cfg = config.my.terminal;

  btopPackage = {
    none = pkgs.btop;
    amd = pkgs.btop-rocm;
    nvidia = pkgs.btop-cuda;
    intel = pkgs.btop;
  }.${config.my.gpu};
in
  {
  options.my.terminal = {
    enable = lib.mkEnableOption "enable my terminal configuration";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      zoxide.enable = true;
      lazygit.enable = true;
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

    systemd.user.sessionVariables = {
      # for zsh
      STARSHIP_CONFIG = "${config.xdg.configHome}/starship/config.toml";
      EDITOR = "nvim";
    };
  };
}
