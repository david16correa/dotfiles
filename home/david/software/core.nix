{ config, lib, pkgs, inputs, unstable, ... }:
{
  imports = [
    ./modules/lazyvim.nix
    inputs.scientific-fhs.nixosModules.default
  ];

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

}
