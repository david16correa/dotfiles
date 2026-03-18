{ inputs, pkgs, unstable, ... }:
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
    "org/gnome/desktop/interface".text-scaling-factor = 1.25;
    "org/cinnamon/desktop/applications/terminal".exec = "kitty";
    # "org/gnome/desktop/interface".gtk-theme = "adw-gtk3-dark";
  };

  xdg = {
    configFile = {
      "gtk-3.0/gtk.css".source = ./config/gtk/tokyo-night.css;
      "gtk-4.0/gtk.css".source = ./config/gtk/tokyo-night.css;
      "environment.d/gtk.conf".source = ./config/environment.d/gtk.conf;
    };
  };

  gtk = {
      enable = true;
      theme = {
          name = "adw-gtk3-dark";
          # name = "Adwaita-dark";
          # name = "Adwaita";
          package = pkgs.gnome-themes-extra;
      };
      iconTheme = {
          name = "Adwaita";
          package = pkgs.adwaita-icon-theme;
      };
      cursorTheme = {
          name = "Adwaita";
          package = pkgs.adwaita-icon-theme;
          size = 24;
      };
  };
}
