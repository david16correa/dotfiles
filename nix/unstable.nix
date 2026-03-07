# Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, unstable, inputs, ... }:

{
  ########################################
  # program modules
  ########################################

  programs.steam.enable = true;

  ########################################
  # system packages
  ########################################

  environment.systemPackages = with pkgs; [
    vicinae
    yazi
    kitty
    neovim
    noctalia-shell
  ]++[
    inputs.zen-browser.packages."${pkgs.system}".default
  ];

  ########################################
  # services
  ########################################

  # services.openssh.enable = true;
}
