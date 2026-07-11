{ lib, config, pkgs, ... }:
let
  cfg = config.my.devel;
in
{
  imports = [
    ./virtualisation.nix
    ./keyd.nix
  ];

  options.my.devel = {
    enable = lib.mkEnableOption "My devel module";
  };

  config = lib.mkIf cfg.enable {

    my.devel = {
      keyd.enable = lib.mkDefault true;
      virtualisation.enable = lib.mkDefault true;
    };

    users.users.david.shell = pkgs.zsh;

    programs = {
      zsh.enable = true;
      git = {
        enable = true;
        config = {
          init.defaultBranch = "main";
          url."https://github.com/".insteadOf = [
            "gh:"
            "github:"
          ];
          user = {
            name = "David Correa";
            email = "david.correa.msc@gmail.com";
          };
        };
      };
      neovim = {
        enable = true;
        viAlias = true;
        vimAlias = true;
      };
    };

    environment = {
      systemPackages = with pkgs; [
        busybox
        killall
      ];
      variables = {
        EDITOR = "vim";
        VISUAL = "vim";
      };
    };

  };
}
