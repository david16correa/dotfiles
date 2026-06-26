{ config, lib, pkgs, inputs, unstable, ... }:
let
  configDir = "${config.home.homeDirectory}/.dotfiles/home/david/software/config";
in
  {
  home = {
    file = {
      ".zshrc" = {
        source = config.lib.file.mkOutOfStoreSymlink "${configDir}/zsh/zshrc";
      };
      ".tmux" = {
        source = config.lib.file.mkOutOfStoreSymlink "${configDir}/tmux/.tmux";
        recursive = true;
      };
      ".tmux.conf" = {
        source = config.lib.file.mkOutOfStoreSymlink "${configDir}/tmux/.tmux.conf";
      };
      ".myScripts" = {
        source = config.lib.file.mkOutOfStoreSymlink "${configDir}/myScripts";
        recursive = true;
      };
      ".vimrc" = {
        source = config.lib.file.mkOutOfStoreSymlink "${configDir}/vim/vimrc";
      };
      ".face.icon" = {
        source = config.lib.file.mkOutOfStoreSymlink "${configDir}/avatar/grinningCoffee.png";
      };
      "Pictures/Wallpapers" = {
        source = config.lib.file.mkOutOfStoreSymlink "${configDir}/wallpapers";
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
        source = config.lib.file.mkOutOfStoreSymlink "${configDir}/niri";
        recursive = true;
      };
      "noctalia" = {
        source = config.lib.file.mkOutOfStoreSymlink "${configDir}/noctalia";
        recursive = true;
      };
      "kitty/kitty.conf" = {
        source = config.lib.file.mkOutOfStoreSymlink "${configDir}/kitty/kitty.conf";
      };
      "starship/config.toml" = {
        source = config.lib.file.mkOutOfStoreSymlink "${configDir}/starship/config.toml";
      };
      "yazi" = {
        source = config.lib.file.mkOutOfStoreSymlink "${configDir}/yazi";
        recursive = true;
      };
      "fastfetch" = {
        source = config.lib.file.mkOutOfStoreSymlink "${configDir}/fastfetch";
        recursive = true;
      };
      "vicinae" = {
        source = config.lib.file.mkOutOfStoreSymlink "${configDir}/vicinae";
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
