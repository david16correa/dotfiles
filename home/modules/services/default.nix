{ lib, config, pkgs, static, inputs, ... }:
let
  cfg = config.my.services;
in
{
  imports = [
    ./usb-sound-watcher.nix
  ];

  options.my.services = {
    enable = lib.mkEnableOption "Enable all my custom user services";
  };

  config = lib.mkIf cfg.enable {
    ########################################
    # user services
    ########################################
    my.usb-sound-watcher.enable = true;
  };
}
