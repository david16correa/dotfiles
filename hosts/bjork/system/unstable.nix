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

  ########################################
  # system packages
  ########################################

  environment.systemPackages = with unstable; [
    vicinae
    yazi
    noctalia-shell
  ];

  ########################################
  # services
  ########################################

}
