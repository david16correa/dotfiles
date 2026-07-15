{ lib, config, pkgs, static, inputs, ... }:
let
  cfg = config.my.office;
in
{
  options.my.office = {
    enable = lib.mkEnableOption "enable my office configuration";
  };

  config = lib.mkIf cfg.enable {
    ########################################
    # home packages
    ########################################
    home.packages = with pkgs; [
      pdftk
      poppler-utils # pdf rendering library
      libreoffice-fresh
      static.texliveFull
    ];
  };
}
