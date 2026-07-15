{ lib, config, pkgs, inputs, ... }:
let
  cfg = config.my.de;
in
{
  options.my.de = {
    enable = lib.mkEnableOption "enable my desktop environment (shell) configuration (noctalia)";
  };

  config = lib.mkIf cfg.enable {
    ########################################
    # home packages
    ########################################
    home.packages = with pkgs; [
      dmidecode
      playerctl
      brightnessctl
      ddcutil
      gnome-firmware
      cliphist
      app2unit
      noctalia-shell
      vicinae
      maestral
      maestral-gui
      libcanberra-gtk3
    ];

    ########################################
    # user services
    ########################################
    services.polkit-gnome.enable = true;

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
    # session variables
    ########################################
    systemd.user.sessionVariables = {
      QT_QPA_PLATFORMTHEME = "gtk3"; # https://docs.noctalia.dev/v4/getting-started/faq/#why-are-some-of-my-app-icons-missing
    };
  };
}
