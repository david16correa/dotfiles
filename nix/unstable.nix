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
    neovim
    noctalia-shell
    julia
  ]++[
    inputs.zen-browser.packages."${pkgs.system}".default
  ];

  ########################################
  # services
  ########################################

  # services.openssh.enable = true;
}
