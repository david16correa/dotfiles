{ pkgs, unstable, inputs, ... }:

{
  imports = [
    ./lazyvim.nix
    ./theme.nix
    inputs.scientific-fhs.nixosModules.default
  ];

  home = {
    stateVersion = "25.11"; # do no NOT change this, unless you know what you're doing
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
    };
  };

  xdg = {
    enable = true;

    userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = false;
    };

    # some of my dotfiles
    configFile = {
      "fastfetch/config.jsonc".source = ./config/fastfetch/config.jsonc;
      "fastfetch/logo.png".source = ./config/fastfetch/logo.png;
      "kitty/kitty.conf".source = ./config/kitty/kitty.conf;
      "starship/config.toml".source = ./config/starship/config.toml;
      "yazi" = {
        source = ./config/yazi;
        recursive = true;
      };
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
  };

  # services = { };
}
