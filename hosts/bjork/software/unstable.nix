{ config, lib, unstable, inputs, ... }:

{
  ########################################
  # program modules
  ########################################

  programs = {
    steam = {
      enable = true;
      package = unstable.steam;
      gamescopeSession.enable = true; # a microcompositor from Valve that is tailored towards gaming
    };
    gamemode.enable = true; # improve CPU governor, scheduling, and I/O priority while gaming
  };

  environment.variables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/david/.steam/root/compatibilitytools.d";
  };
}
