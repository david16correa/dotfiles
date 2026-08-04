{ config, lib, pkgs, inputs, ... }:
let
  cfg = config.my.config;

  configPath = "${config.home.homeDirectory}/.dotfiles/home/modules/de/configFiles";

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
  options.my.config = {
    avatar.enable = lib.mkEnableOption "enable my face icon";
    colors.enable = lib.mkEnableOption "enable my gtk colors";
    niri.enable = lib.mkEnableOption "enable my niri configs";
    noctalia.enable = lib.mkEnableOption "enable my noctalia configs";
    vicinae.enable = lib.mkEnableOption "enable my vicinae configs";
    wallpapers.enable = lib.mkEnableOption "enable my wallpapers configs";
  };

  config = lib.mkMerge[
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
