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
      # package = pkgs.gnome-themes-extra;
      package = pkgs.adw-gtk3;
    };
    gtk4.theme = null; # stateVersion compatibility config; new default adoption
    iconTheme = {
      # name = "Adwaita";
      # package = pkgs.adwaita-icon-theme;
      name = "MoreWaita";
      package = pkgs.morewaita-icon-theme;
    };
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
    };
  };

  # flatpak theming
  home.activation.flatpakOverrides = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # I use a cache to skip this entire activation script if the desired applications have not changed!
    if ! ${pkgs.busybox}/bin/cmp -s /var/cache/flatpak-appList $HOME/.cache/my.flatpak/flatpak-appList; then
      run ${pkgs.flatpak}/bin/flatpak override --user --filesystem=$HOME/.local/share/icons:ro
      run ${pkgs.flatpak}/bin/flatpak override --user --filesystem=/nix/store:ro
      run ${pkgs.flatpak}/bin/flatpak override --user --env=XCURSOR_THEME=Adwaita
      run ${pkgs.flatpak}/bin/flatpak override --user --env=XCURSOR_SIZE=24

      mkdir -p $HOME/.cache/my.flatpak
      cat /var/cache/flatpak-appList > $HOME/.cache/my.flatpak/flatpak-appList
    fi
  '';
}
