{ lib, config, pkgs, ... }:
{
  # I abstract the directory of my flake so I can use it in more than one place
  options.my.flakeDir = lib.mkOption {
    type = lib.types.str;
    default = "/home/david/.dotfiles";
    description = "Absolute path to the dotfiles flake checkout, used to derive paths like programs.nh.flake.";
    example = "/home/david/.dotfiles";
  };

  config.programs.nh.flake = lib.mkDefault config.my.flakeDir;
}
