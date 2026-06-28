{ config, lib, pkgs, inputs, ... }:
{
  ########################################
  # program modules
  ########################################

  programs = {
    home-manager.enable = true;

    git = {
      enable = true;
      settings.user = {
        name = "David Correa";
        email = "david.correa.msc@gmail.com";
      };
    };

    scientific-fhs = {
      enable = true;
      juliaVersions = [
        { version = "1.11.6"; default = true; }
      ];
      enableNVIDIA = false;
      enableGraphical = true;  # needed for plotting, REPL graphics etc.
    };
  };

  ########################################
  # home packages
  ########################################

  home.packages = with pkgs; [
    kitty
    trashy
    tmux
    fastfetch
    stow
    btop-rocm
    tree
    tealdeer
    which
    rsync
    caligula
    gcc
    gum
    dmidecode
    gh
    playerctl
    brightnessctl
    ddcutil
    compsize
    gnome-firmware
  ];

  ########################################
  # desktop entries
  ########################################

  xdg.desktopEntries = {
    nix_search_pkgs = {
      name = "NixOS Search: Packages";
      icon = "nix-snowflake";
      genericName = "System Manual (Package Search)";
      exec = "xdg-open https://search.nixos.org/packages";
      terminal = false;
      categories = [ "System" ];
    };
    nix_search_opts = {
      name = "NixOS Search: Options";
      icon = "nix-snowflake";
      genericName = "System Manual (Options Search)";
      exec = "xdg-open https://search.nixos.org/options";
      terminal = false;
      categories = [ "System" ];
    };
  };

  ########################################
  # user services
  ########################################

  services.polkit-gnome.enable = true;

}
