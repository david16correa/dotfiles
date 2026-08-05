{ config, lib, pkgs, inputs, ... }:
let
  cfg = config.my.configs;

  configPath = "${config.home.homeDirectory}/.dotfiles/home/modules/configs/configFiles";

  # custom outOfStoreSymlinks
  mkLink = enable: target: source:
    lib.mkIf enable {
      home.file.${target}.source = config.lib.file.mkOutOfStoreSymlink "${configPath}/${source}";
    };

  # custom outOfStoreSymlinks; recursive. Useful when target needs to be kept as an actual directory
  mkReLink = enable: target : source :
    lib.mkIf enable {
      home.file =
        let
          files = builtins.attrNames (builtins.readDir ./configFiles/${source});
        in
          builtins.listToAttrs (
            map (file: {
              name = "${target}/${file}";
              value.source = config.lib.file.mkOutOfStoreSymlink  "${configPath}/${source}/${file}";
            }) files
          );
    };
in
  {
  options.my.configs = {
    # tty
    fastfetch.enable = lib.mkEnableOption "enable my fastfetch configs";
    kitty.enable = lib.mkEnableOption "enable my kitty configs";
    scripts.enable = lib.mkEnableOption "enable my scripts";
    starship.enable = lib.mkEnableOption "enable my starship configs";
    tmux.enable = lib.mkEnableOption "enable my tmux configs";
    vim.enable = lib.mkEnableOption "enable my vim configs";
    yazi.enable = lib.mkEnableOption "enable my yazi configs";
    zsh.enable = lib.mkEnableOption "enable my zsh configs";
    # de
    avatar.enable = lib.mkEnableOption "enable my face icon";
    colors.enable = lib.mkEnableOption "enable my gtk colors";
    niri.enable = lib.mkEnableOption "enable my niri configs";
    noctalia.enable = lib.mkEnableOption "enable my noctalia configs";
    vicinae.enable = lib.mkEnableOption "enable my vicinae configs";
    wallpapers.enable = lib.mkEnableOption "enable my wallpapers configs";
  };

  config = lib.mkMerge[
    # tty
    (mkLink cfg.fastfetch.enable "${config.xdg.configHome}/fastfetch" "fastfetch")
    (mkLink cfg.kitty.enable "${config.xdg.configHome}/kitty" "kitty")
    (mkReLink cfg.scripts.enable "${config.xdg.binHome}" "scripts")
    (mkLink cfg.starship.enable "${config.xdg.configHome}/starship" "starship")
    (mkLink cfg.tmux.enable ".tmux" "tmux/tmux")
    (mkLink cfg.tmux.enable ".tmux.conf" "tmux/tmux.conf")
    (mkLink cfg.vim.enable ".vimrc" "vim/vimrc")
    (mkLink cfg.yazi.enable "${config.xdg.configHome}/yazi" "yazi")
    (mkLink cfg.zsh.enable ".zshrc" "zsh/zshrc")
    # de
    (mkLink cfg.avatar.enable ".face.icon" "avatar/grinningCoffee.png")
    (mkLink cfg.colors.enable "${config.xdg.configHome}/gtk-3.0/gtk.css" "colors/gtk/gtk.css")
    (mkLink cfg.colors.enable "${config.xdg.configHome}/gtk-4.0/gtk.css" "colors/gtk/gtk.css")
    (mkLink cfg.colors.enable "${config.xdg.configHome}/gtk-3.0/noctalia.css" "colors/gtk/colors.css")
    (mkLink cfg.colors.enable "${config.xdg.configHome}/gtk-4.0/noctalia.css" "colors/gtk/colors.css")
    (mkLink cfg.colors.enable "${config.xdg.configHome}/qt5ct" "colors/qt")
    (mkLink cfg.colors.enable "${config.xdg.configHome}/qt6ct" "colors/qt")
    (mkLink cfg.niri.enable "${config.xdg.configHome}/niri" "niri")
    (mkLink cfg.noctalia.enable "${config.xdg.configHome}/noctalia" "noctalia")
    (mkLink cfg.vicinae.enable "${config.xdg.configHome}/vicinae" "vicinae")
    (mkLink cfg.wallpapers.enable "Pictures/Wallpapers" "wallpapers")
  ];
}
