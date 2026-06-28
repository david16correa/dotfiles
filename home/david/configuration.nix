{ config, lib, pkgs, inputs, ... }:
let
  symlink = path : config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/home/david/software/config/${path}";
in
  {
  home.file = {
    ".zshrc".source = symlink "zsh/zshrc";
    ".tmux".source = symlink "tmux/.tmux";
    ".tmux.conf".source = symlink "tmux/.tmux.conf";
    ".face.icon".source = symlink "avatar/grinningCoffee.png";
    ".myScripts".source = symlink "myScripts";
    "Pictures/Wallpapers".source = symlink "wallpapers";
  };

  xdg = {
    enable = true;

    userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = false; # stateVersion compatibility config; new default adoption
    };

    configFile = {
      "niri".source = symlink "niri";
      "noctalia".source = symlink "noctalia";
      "kitty".source = symlink "kitty";
      "starship".source = symlink "starship";
      "yazi".source = symlink "yazi";
      "fastfetch".source = symlink "fastfetch";
      "vicinae".source = symlink "vicinae";
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
}
