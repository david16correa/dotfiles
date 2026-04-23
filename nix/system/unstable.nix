{ config, lib, unstable, inputs, ... }:

{
  ########################################
  # program modules
  ########################################

  programs.steam = {
      enable = true;
      package = unstable.steam;
  };

  ########################################
  # system packages
  ########################################

  environment.systemPackages = with unstable; [
    vicinae
    yazi
    kitty
    # neovim
    noctalia-shell
    # julia
    discord
  ];

  ########################################
  # services
  ########################################

  # services.openssh.enable = true;
}
