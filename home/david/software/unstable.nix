{ config, lib, unstable, inputs, ... }:
{
  ########################################
  # home packages
  ########################################

  home.packages = with unstable; [
    vicinae
    yazi
    noctalia-shell
  ];

}
