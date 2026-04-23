{ config, lib, static, inputs, ... }:

{
  ########################################
  # program modules
  ########################################

  ########################################
  # system packages
  ########################################

  environment.systemPackages = with static; [
    texliveFull # needed for textext in inkscape, and for LaTeX support (duh)
  ];

  ########################################
  # services
  ########################################

  # services.openssh.enable = true;
}
