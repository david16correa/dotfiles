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
    "/".options     = [ "compress=zstd" "noatime" ];
    "/home".options = [ "compress=zstd" "noatime" ];
    "/nix".options  = [ "compress=zstd" "noatime" ];
    "/swap".options = [ "noatime" ];
    "/home/.snapshots".options  = [ "compress=zstd" "noatime" ];
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
  };
}
