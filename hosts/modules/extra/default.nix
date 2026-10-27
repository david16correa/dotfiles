{ lib, config, pkgs, unstable, ... }:
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
        # package = unstable.steam;
      };
      gamescope = { # a micro-compositor to wrap games; fixes windowing issues, enables upscaling, and improves performance
        enable = true;
        # capSysNice = true; # no bueno
        # package = unstable.gamescope;
      };
      # gamemode.enable = true; # improve CPU governor, scheduling, and I/O priority while gaming
    };

    ########################################
    # services
    ########################################
    services.ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-rules-cachyos;
    };

    ########################################
    # extra
    ########################################
    environment.variables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/david/.steam/root/compatibilitytools.d";
    };
  };
}
