{ pkgs, unstable, inputs, ... }:

{
  imports = [
    ./lazyvim.nix
    ./theme.nix
    inputs.scientific-fhs.nixosModules.default
  ];

  home = {
    stateVersion = "25.11"; # do NOT change this
    # packages = with pkgs; [ ];
    file = {
      ".tmux.conf".source = ./config/tmux/.tmux.conf;
      ".tmux" = {
        source = ./config/tmux/.tmux;
        recursive = true;
      };
      ".backgrounds" = {
        source = ./backgrounds;
        recursive = true;
      };
      ".face".source = ./avatar/grinningCoffee.jpg;
      # ".gnome2/accels/nemo".text = ''
      #   (gtk_accel_path "<Actions>/DirViewActions/OpenInTerminal" "<Primary>Return")
      # '';
    };
  };

  dconf.settings = {
    # "org/cinnamon/desktop/applications/terminal".exec = "kitty";
    # "org/cinnamon/desktop/interface".can-change-accels = true;
    # "org/gnome/desktop/interface".gtk-theme = "adw-gtk3-dark";
  };

  xdg = {
    enable = true;
    # /home/* directories
    userDirs.enable = true;
    userDirs.createDirectories = true;
    # my dotfiles
    configFile = {
      "fastfetch/config.jsonc".source = ./config/fastfetch/config.jsonc;
      "kitty/kitty.conf".source = ./config/kitty/kitty.conf;
      "starship/config.toml".source = ./config/starship/config.toml;
      "yazi" = {
        source = ./config/yazi;
        recursive = true;
      };
      "leovim" = {
        source = ./config/leovim;
        recursive = true;
      };
      # "niri" = {
      #   source = ./config/niri;
      #   recursive = true;
      # };
    };
    desktopEntries = {
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
  };

  programs = {
    scientific-fhs = {
      enable = true;
      juliaVersions = [
        { version = "1.11.6"; default = true; }
      ];
      enableNVIDIA = false;
      enableGraphical = true;  # needed for plotting, REPL graphics etc.
    };
    mangohud = {
      enable = true;
      settings = {
        fps = true;
        frametime = true;
        position="top-left";
        font_size=16;
        background_alpha=0.2;
        round_corners=10;
        alpha=0.9;
        no_display = true;
        toggle_hud="Shift+F5";
      };
    };
  };

  services = {
    spotifyd = {
      enable = true;
      settings.global = {
        zeroconf_port = 2020;
        bitrate = 320;
        backend = "alsa";
        volume_normalisation = false;
        volume_controller = "none";
        initial_volume = 100;
      };
    };
  };
}
