{ lib, config, pkgs, ... }:
let
  cfg = config.my.dm;
in
{
  options.my.dm = {
    enable = lib.mkEnableOption "My display manager module (sddm)";
  };

  config = lib.mkIf cfg.enable {
    ########################################
    # system packages
    ########################################
    environment = {
      systemPackages = with pkgs; [
        bibata-cursors
        (catppuccin-sddm.override {
          flavor = "macchiato";
          accent = "blue";
          clockEnabled = false;
          font  = "Adwaita Sans";
          fontSize = "9";
          background = "${./configFiles/dm16_10.jpg}";
          loginBackground = true;
          # userIcon = true;
        })
      ];
      etc."sddm.extra/faces/david.face.icon".source = ./configFiles/grinningCoffee.png;
    };

    ########################################
    # services
    ########################################
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      wayland.compositor = "kwin";
      theme = "catppuccin-macchiato-blue";
      settings = {
        Theme = {
          CursorTheme = "Bibata-Modern-Classic";
          CursorSize = 24;
          FacesDir="/config/sddm.extra/faces/";
        };
        Users.RememberLastSession=false;
      };
    };
  };
}
