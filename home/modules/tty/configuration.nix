{ config, lib, pkgs, inputs, ... }:
let
  cfg = config.my.config;

  configPath = "${config.home.homeDirectory}/.dotfiles/home/modules/tty/configFiles";

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
    fastfetch.enable = lib.mkEnableOption "enable my fastfetch configs";
    kitty.enable = lib.mkEnableOption "enable my kitty configs";
    scripts.enable = lib.mkEnableOption "enable my scripts";
    starship.enable = lib.mkEnableOption "enable my starship configs";
    tmux.enable = lib.mkEnableOption "enable my tmux configs";
    vim.enable = lib.mkEnableOption "enable my vim configs";
    yazi.enable = lib.mkEnableOption "enable my yazi configs";
    zsh.enable = lib.mkEnableOption "enable my zsh configs";
  };

  config = lib.mkMerge[
    (mkLink cfg.fastfetch.enable "${config.xdg.configHome}/fastfetch" "fastfetch")
    (mkLink cfg.kitty.enable "${config.xdg.configHome}/kitty" "kitty")
    (mkReLink cfg.scripts.enable "${config.xdg.binHome}" "scripts")
    (mkLink cfg.starship.enable "${config.xdg.configHome}/starship" "starship")
    (mkLink cfg.tmux.enable ".tmux" "tmux/tmux")
    (mkLink cfg.tmux.enable ".tmux.conf" "tmux/tmux.conf")
    (mkLink cfg.vim.enable ".vimrc" "vim/vimrc")
    (mkLink cfg.yazi.enable "${config.xdg.configHome}/yazi" "yazi")
    (mkLink cfg.zsh.enable ".zshrc" "zsh/zshrc")
  ];
}
