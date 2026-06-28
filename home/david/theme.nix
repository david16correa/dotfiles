{ config, lib, pkgs, inputs, unstable, ... }:
{
  home = {
    packages = with pkgs; [
      adw-gtk3
    ];

    pointerCursor = {
      gtk.enable = true;
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface".text-scaling-factor = 1.15;
    "org/gnome/desktop/wm/preferences".button-layout = ":";
  };

  xdg = {
    configFile = {
      "gtk-3.0/gtk.css".source = ./software/config/gtk/tokyo-night.css;
      "gtk-4.0/gtk.css".source = ./software/config/gtk/tokyo-night.css;
      "environment.d/gtk.conf".source = ./software/config/environment.d/gtk.conf;
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    gtk4.theme = null; # stateVersion compatibility config; new default adoption
    iconTheme = {
      name = "MoreWaita";
      package = pkgs.morewaita-icon-theme;
    };
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
    };
  };
}
