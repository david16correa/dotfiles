{ config, lib, ... }:
let
  cfg = config.my.configs;

  configPath = "modules/configs/configFiles";

  mkConfigOption = name: {
    enable = lib.mkEnableOption name;
    recursive = lib.mkEnableOption "recursive";
    source = lib.mkOption {
      type = lib.types.str;
      default = "${configPath}/${name}";
      description = "source for config files relative to /path/to/dotfiles/home (very important!!)";
    };
    target = lib.mkOption {
      type = lib.types.either
        lib.types.str
        (lib.types.listOf lib.types.str);
      default = "${config.xdg.configHome}/${name}";
    };
  };

  configNames = [
    # tty
    "fastfetch"
    "kitty"
    "scriptsBase"
    "scriptsExtra"
    "starship"
    "tmux"
    "vim"
    "yazi"
    "zsh"
    # de
    "avatar"
    "colorsGtk"
    "colorsQt"
    "niri"
    "noctalia"
    "vicinae"
    "wallpapers"
  ];
in{
  options.my.configs = builtins.listToAttrs (
    map (configName : {
      name = configName;
      value = mkConfigOption configName;
    }) configNames
    ) // {
      colors.enable = lib.mkEnableOption "colors";
      scripts.enable = lib.mkEnableOption "scripts";
      extra = lib.mkOption{
        type = lib.types.attrs;
        default = { }; # no extra configs are defined by default
        description = "Extra configs";
      };
    };

  # non-default stuff
  config.my.configs = {
    # tty
    scriptsBase = {
      enable = cfg.scripts.enable;
      recursive = true;
      source = "${configPath}/scripts/base";
      target = "${config.xdg.binHome}";
    };
    scriptsExtra = {
      enable = cfg.scripts.enable;
      recursive = true;
      source = "${configPath}/scripts/extra";
      target = "${config.xdg.binHome}";
    };
    tmux = {
      recursive = true;
      target = "${config.home.homeDirectory}";
    };
    vim = {
      recursive = true;
      target = "${config.home.homeDirectory}";
    };
    zsh = {
      recursive = true;
      target = "${config.home.homeDirectory}";
    };
    # de
    avatar = {
      recursive = true;
      target = "${config.home.homeDirectory}";
    };
    colorsGtk = {
      enable = cfg.colors.enable;
      recursive = true;
      source = "${configPath}/colors/gtk";
      target = [
        "${config.xdg.configHome}/gtk-3.0"
        "${config.xdg.configHome}/gtk-4.0"
      ];
    };
    colorsQt = {
      enable = cfg.colors.enable;
      source = "${configPath}/colors/qt";
      target = [
        "${config.xdg.configHome}/qt5ct"
        "${config.xdg.configHome}/qt6ct"
      ];
    };
    wallpapers.target = "${config.home.homeDirectory}/Pictures/Wallpapers";
  };
}
