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
  home.packages = with pkgs; [
    alsa-utils
  ];

  ########################################
  # dotfiles and user directories
  ########################################

  # home.file = {
  #   ".zshrc".source = symlink "zsh/zshrc";
  #   ".tmux".source = symlink "tmux/.tmux";
  #   ".tmux.conf".source = symlink "tmux/.tmux.conf";
  # } //
  #   recursiveSymlink "${config.xdg.binHome}" "myScripts";
  #
  # xdg = {
  #   enable = true;
  #
  #   configFile = {
  #     "starship".source = symlink "starship";
  #     "yazi".source = symlink "yazi";
  #     "fastfetch".source = symlink "fastfetch";
  #   };
  # };
}
