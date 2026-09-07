{ config, lib, pkgs, inputs, ... }:

{
  ########################################
  # bootloader, kernel, etc
  ########################################
  boot = {
    kernelParams = [
      "resume_offset=2963592"  # for hibernation
    ];
    resumeDevice = config.fileSystems."/swap".device;
  };

  fileSystems = {
    "/".options                       =   [ "compress=zstd" "noatime" ];
    "/home".options                   =   [ "compress=zstd" "noatime" ];
    "/nix".options                    =   [ "compress=zstd" "noatime" ];
    "/swap".options                   =   [ "noatime" ];
    "/home/david/.snapshots".options  =   [ "compress=zstd" "noatime" ];
    "/home/gamer/sdX".options         =   [ "compress=zstd" "noatime" ];
  };

  swapDevices = [{
    device = "/swap/swapfile";
    size = 32*1024;
  }];

  ########################################
  # OS basics
  ########################################
  networking = {
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
    firewall.allowedTCPPorts = [8888]; # jupyter
  };

  hardware = {
    cpu.amd.updateMicrocode = true;
    bluetooth = {
      enable = true;
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
      open = true;
      modesetting.enable = true;
      nvidiaSettings = true;
    };
  };

  ########################################
  # services
  ########################################
  systemd.services.NetworkManager-wait-online.enable = false;

  services = {
    xserver.videoDrivers = [ "nvidia" ];
    automatic-timezoned.enable = lib.mkForce false;
    snapper = {
      snapshotInterval = "hourly";
      configs.home = {
        SUBVOLUME = "/home/david";
        ALLOW_USERS = [ "david" ];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_HOURLY = 8;
        TIMELINE_LIMIT_DAILY = 7;
        TIMELINE_LIMIT_WEEKLY = 4;
        TIMELINE_LIMIT_MONTHLY = 3;
        TIMELINE_LIMIT_YEARLY = 0;
      };
    };
  };
}
