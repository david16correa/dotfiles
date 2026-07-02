{ config, lib, pkgs, inputs, unstable, ... }:
let
  symlink = path : config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/home/david/software/config/${path}";
in
{
  home = {
    packages = with pkgs; [
      adw-gtk3
    ];

    pointerCursor = {
      gtk.enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 16;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface".text-scaling-factor = 1.15;
    "org/gnome/desktop/wm/preferences".button-layout = ":";
  };

  xdg = {
    configFile = {
      "gtk-3.0/gtk.css".source = symlink "colors/gtk/gtk.css";
      "gtk-4.0/gtk.css".source = symlink "colors/gtk/gtk.css";
      "gtk-3.0/noctalia.css".source = symlink "colors/gtk/colors.css";
      "gtk-4.0/noctalia.css".source = symlink "colors/gtk/colors.css";
      "qt5ct".source = symlink "colors/qt";
      "qt6ct".source = symlink "colors/qt";
      "environment.d/gtk.conf".source = symlink "environment.d/gtk.conf";
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
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
    };
  };
}
