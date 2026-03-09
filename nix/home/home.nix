{ pkgs, ... }:

{
  xdg = {
    enable = true;
    userDirs.enable = true;
    userDirs.createDirectories = true;
    configFile = {
      "gtk-3.0/gtk.css".source = ./gtk/tokyo-night.css;
      "gtk-4.0/gtk.css".source = ./gtk/tokyo-night.css;
    };
  };

  gtk = {
      enable = true;
      theme = {
          name = "Adwaita-dark";
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

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
  };

  home.stateVersion = "25.11"; # the state version is required and should stay at the version you originally installed
}
