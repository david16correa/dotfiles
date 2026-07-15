{ lib, config, pkgs, ... }:
let
  cfg = config.my.extra;
in
{
  options.my.extra = {
    enable = lib.mkEnableOption "My extra module (gaming)";
  };

  config = lib.mkIf cfg.enable {
    ########################################
    # program modules
    ########################################

    programs = {
      steam = {
        enable = true;
        gamescopeSession.enable = true; # a microcompositor from Valve that is tailored towards gaming
      };
      gamemode.enable = true; # improve CPU governor, scheduling, and I/O priority while gaming
    };

    ########################################
    # extra
    ########################################

    hardware.graphics.enable32Bit = true;

    environment.variables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/david/.steam/root/compatibilitytools.d";
    };
  };
}
