{ lib, config, pkgs, ... }:
let
  cfg = config.my.steamConsole;
in
  {
  options.my.steamConsole = {
    enable = lib.mkEnableOption "My steam console setup";
  };

  config = lib.mkIf cfg.enable {
    users.users.gamer = {
      description = "User for gamescope session";
      isNormalUser = true;
      extraGroups = [  "networkmanager" "gamemode" "audio" ];
      hashedPassword = null;
    };

    networking.networkmanager.enable = lib.mkForce true; # needed by gamescope session! E.g. shutdown won't work without it, somehow

    services.pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      wireplumber.enable = true;
    };

    security.rtkit.enable = true;

    # docs: https://jovian-experiments.github.io/Jovian-NixOS/options.html
    jovian  = {
      steam = {
        enable = true; # note: also enables jovian.steamos.useSteamOSConfig! This brings several modules. Some are useless to me
        autoStart = true;
        user = "gamer";
        desktopSession = "gamescope-wayland"; # I have to change this later
      };
      steamos = {
        enableZram = false; # enabled by jovian.steamos.useSteamOSConfig; incompatible with my setup (I use zswap)
        enableHdmiCecIntegration = false; # enabled by jovian.steamos.useSteamOSConfig; unneeded
      };
    };
  };
}
