{ config, lib, unstable, inputs, ... }:
{
  ########################################
  # program modules
  ########################################

  # programs = {
  # };

  ########################################
  # home packages
  ########################################

  home.packages = with unstable; [
    vicinae
    yazi
    noctalia-shell
  ];

}
