{ config, lib, pkgs, inputs, ... }:
let
  # custom outOfStoreSymlinks
  symlink = source : config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/home/david/configFiles/${source}";

  # custom outOfStoreSymlinks; recursive. Useful when target needs to be kept as an actual directory
  recursiveSymlink = target : source :
    let
      files = builtins.attrNames (builtins.readDir ./configFiles/${source});
    in
    builtins.listToAttrs (
      map (file: {
        name = "${target}/${file}";
        value.source = symlink "${source}/${file}";
      }) files
    );
in
  {
  ########################################
  # program modules
  ########################################
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

  ########################################
  # dotfiles and user directories
  ########################################
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

    mimeApps = {
      enable = true;
      defaultApplications = {
        # File explorer
        "inode/directory" = [ "org.gnome.Nautilus.desktop" ];
        # Browser
        "text/html" = [ "zen-beta.desktop" ];
        "x-scheme-handler/http" = [ "zen-beta.desktop" ];
        "x-scheme-handler/https" = [ "zen-beta.desktop" ];
        # Images
        "image/png" = [ "org.gnome.Loupe.desktop" ];
        "image/jpeg" = [ "org.gnome.Loupe.desktop" ];
        "image/svg+xml" = [ "org.inkscape.Inkscape.desktop" ];
        # Documents
        "application/pdf" = [ "org.gnome.Evince.desktop" ];
      };
    };
  };

  ########################################
  # session variables
  ########################################
  systemd.user.sessionVariables = {
    # for julia
    JULIA_NUM_THREADS = "auto"; # by default julia will use all threads
  };
}
