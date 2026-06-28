{ config, lib, static, inputs, ... }:

{
  ########################################
  # home packages
  ########################################

  home.packages = with static; [
    texliveFull # needed for textext in inkscape, and for LaTeX support (duh)
  ];

}
