{ config, lib, pkgs, inputs, ... }:

{
  ########################################
  # bootloader, kernel, etc
  ########################################
  fileSystems = {
    "/".options     = [ "compress=zstd" "noatime" ];
    "/home".options = [ "compress=zstd" "noatime" ];
    "/nix".options  = [ "compress=zstd" "noatime" ];
    "/swap".options = [ "noatime" ];
  };

  swapDevices = [{
    device = "/swap/swapfile";
    size = 16*1024;
  }];

  ########################################
  # OS basics
  ########################################
  hardware = {
    cpu.intel.updateMicrocode = true;
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
    thermald.enable = true;
    xserver.videoDrivers = [ "nvidia" ];
    automatic-timezoned.enable = lib.mkForce false;
  };
}
