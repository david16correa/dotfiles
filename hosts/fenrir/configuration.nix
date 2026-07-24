{ config, lib, pkgs, inputs, ... }:

{
  ########################################
  # bootloader, kernel, etc
  ########################################

  boot.kernelParams = [
    "resume_offset=40698492"  # for hibernation
  ];

  ########################################
  # OS basics
  ########################################

  hardware = {
    cpu.intel.updateMicrocode = true;
    bluetooth = {
      # enable = true;
      settings.General = {
        Experimental = true;
        FastConnectable = true;
      };
    };
    enableAllFirmware = true;
    graphics = {
      enable = true; # OpenGl/AMD
      enable32Bit = true;
    };

    nvidia = {
      open = false;                        # 960M is Maxwell — must use proprietary, NOT the open kernel module
      modesetting.enable = true;
      powerManagement.enable = true;       # helps with suspend/resume
      powerManagement.finegrained = false; # true only works on Turing+, not Maxwell
      nvidiaSettings = true;
      branch = "legacy_580";
    };
  };

  ########################################
  # services
  ########################################

  systemd.services.NetworkManager-wait-online.enable = false;

  services = {
    xserver.videoDrivers = [ "nvidia" ];
    zerotierone.enable = true;

    btrfs.autoScrub = {
      enable = true;
      interval = "weekly";
      fileSystems = [ "/" ];
    };

    openssh = {
      enable = true;
      settings.PermitRootLogin = "no";
      allowSFTP = true;
    };
  };


  ########################################
  # gaming
  ########################################

  users.users.gamer = {
    description = "User for gamescope session";
    isNormalUser = true;
    extraGroups = [  "networkmanager" "gamemode" ];
    hashedPassword = null;
  };

  jovian = {
    steam = {
      enable = true;
      autoStart = true;
      user = "gamer";
      desktopSession = "gamescope-wayland"; # I have to change this later
    };
    devices.steamdeck.enableSoundSupport = true;
  };
}
