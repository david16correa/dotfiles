{ config, lib, pkgs, inputs, ... }:
{
  ########################################
  # program modules
  ########################################

  programs = {
    home-manager.enable = true;

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
    nixpkgsSearch = {
      name = "NixOS Search: Packages";
      icon = "nix-snowflake";
      genericName = "System Manual (Package Search)";
      exec = "xdg-open https://search.nixos.org/packages";
      terminal = false;
      categories = [ "System" ];
    };
    nixoptsSearch = {
      name = "NixOS Search: Options";
      icon = "nix-snowflake";
      genericName = "System Manual (Options Search)";
      exec = "xdg-open https://search.nixos.org/options";
      terminal = false;
      categories = [ "System" ];
    };
    dotfilesRepo = {
      name = "david16correa/dotfiles";
      icon = "nix-snowflake";
      genericName = "Repo of my flake in GitHub";
      exec = "xdg-open https://github.com/david16correa/dotfiles";
      terminal = false;
      categories = [ "System" ];
    };
  };

  ########################################
  # user services
  ########################################

  services.polkit-gnome.enable = true;

}
