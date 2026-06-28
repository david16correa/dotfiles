{ config, lib, pkgs, inputs, ... }:
let
  configDir = "${config.home.homeDirectory}/.dotfiles/home/david/software/config";
  symlink = path : config.lib.file.mkOutOfStoreSymlink "${configDir}/${path}";
in
  {
  home = {
    file = {
      ".zshrc".source = symlink "zsh/zshrc";
      ".tmux.conf".source = symlink "tmux/.tmux.conf";
      ".vimrc".source = symlink "vim/vimrc";
      ".face.icon".source = symlink "avatar/grinningCoffee.png";

      ".tmux" = {
        source = symlink "tmux/.tmux";
        recursive = true;
      };
      ".myScripts" = {
        source = symlink "myScripts";
        recursive = true;
      };
      "Pictures/Wallpapers" = {
        source = symlink "wallpapers";
        recursive = true;
      };
    };
  };

  xdg = {
    enable = true;

    userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = false; # stateVersion compatibility config; new default adoption
    };

    configFile = {
      "niri" = {
        source = symlink "niri";
        recursive = true;
      };
      "noctalia" = {
        source = symlink "noctalia";
        recursive = true;
      };
      "kitty/kitty.conf" = {
        source = symlink "kitty/kitty.conf";
      };
      "starship/config.toml" = {
        source = symlink "starship/config.toml";
      };
      "yazi" = {
        source = symlink "yazi";
        recursive = true;
      };
      "fastfetch" = {
        source = symlink "fastfetch";
        recursive = true;
      };
      "vicinae" = {
        source = symlink "vicinae";
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

}
