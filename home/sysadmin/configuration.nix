{ config, lib, pkgs, inputs, ... }:
let
  # custom outOfStoreSymlinks
  symlink = source : config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/home/sysadmin/configFiles/${source}";

  # custom outOfStoreSymlinks; recursive. Useful when target needs to be kept as an actual directory
  recursiveSymlink = target : source :
    let
      files = builtins.attrNames (builtins.readDir ./configFiles/${source});
    in
      builtins.listToAttrs (
        map (file: {
          name = "${target}/${file}";
          value.source = symlink "${source}/${file}";
        }) files
      );
in
  {
  ########################################
  # home packages
  ########################################
  home.packages = with pkgs; [
    alsa-utils
  ];

  ########################################
  # common and cusotm configs
  ########################################
  my.configs = {
    scripts.base.enable = true;
    starship.enable = true;
    tmux.enable = true;
    zsh.enable = true;
  };

  xdg.configFile = {
    "fastfetch".source = symlink "fastfetch";
    "yazi".source = symlink "yazi";
  };

  ########################################
  # dotfiles and user directories
  ########################################
  home.homeDirectory = "/home/${config.home.username}";
}
