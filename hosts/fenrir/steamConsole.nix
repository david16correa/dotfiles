{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    inputs.jovian-nixos.nixosModules.default
  ];

  users.users.gamer = {
    description = "User for gamescope session";
    isNormalUser = true;
    extraGroups = [  "networkmanager" "gamemode" "audio" ];
    hashedPassword = null;
  };

  networking.networkmanager.enable = lib.mkForce true; # needed by gamescope session! E.g. shutdown won't work without it, somehow

  services = {
    desktopManager.plasma6.enable = true; # for desktop session support
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      wireplumber.enable = true;
    };
  };

  security.rtkit.enable = true;

  # docs: https://jovian-experiments.github.io/Jovian-NixOS/options.html
  jovian  = {
    steam = {
      enable = true; # note: also enables jovian.steamos.useSteamOSConfig! This brings several modules. Some are useless to me
      autoStart = true;
      user = "gamer";
      desktopSession = "plasma";
    };
    steamos = {
      enableZram = false; # enabled by jovian.steamos.useSteamOSConfig; incompatible with my setup (I use zswap)
      enableHdmiCecIntegration = false; # enabled by jovian.steamos.useSteamOSConfig; unneeded
    };
  };

  programs.gamemode = {
    enable = true;
    settings = {
      general.renice = 10;
      # gpu = {
      #   apply_gpu_optimisations = "accept-responsibility";
      #   gpu_device = 0;
      # };
    };
  };

}
