{ config, lib, pkgs, inputs, ... }:
let
  # custom outOfStoreSymlinks
  symlink = source : config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/home/david/software/config/${source}";

  # custom outOfStoreSymlinks; recursive. Useful when target needs to be kept as an actual directory
  recursiveSymlink = target : source :
    let
      files = builtins.attrNames (builtins.readDir ./software/config/${source});
    in
    builtins.listToAttrs (
      map (file: {
        name = "${target}/${file}";
        value.source = symlink "${source}/${file}";
      }) files
    );
in
  {
  home.file = {
    ".zshrc".source = symlink "zsh/zshrc";
    ".tmux".source = symlink "tmux/.tmux";
    ".tmux.conf".source = symlink "tmux/.tmux.conf";
    ".face.icon".source = symlink "avatar/grinningCoffee.png";
    "Pictures/Wallpapers".source = symlink "wallpapers";
  } //
    recursiveSymlink "${config.xdg.binHome}" "myScripts";

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
      "btop".source = symlink "btop";
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
