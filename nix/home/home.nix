{ pkgs, unstable, inputs, ... }:

{
  imports = [
    ./lazyvim.nix
  ];

  home = {
    packages = with unstable; [
      adw-gtk3
      statix
      tree-sitter
    ];

    pointerCursor = {
      gtk.enable = true;
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
    };

    stateVersion = "25.11"; # the state version is required and should stay at the version you originally installed
  };

  dconf.settings = {
    "org/gnome/desktop/interface".text-scaling-factor = 1.25;
    # "org/gnome/desktop/interface".gtk-theme = "adw-gtk3-dark";
  };

  xdg = {
    enable = true;
    userDirs.enable = true;
    userDirs.createDirectories = true;
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
