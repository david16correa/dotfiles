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
  networking.networkmanager = {
    enable = true; # needed by gamescope session! E.g. shutdown won't work without it, somehow
    wifi.powersave = false;
  };

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

    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      wireplumber.enable = true;
    };
  };

  security.rtkit.enable = true;

  ########################################
  # gaming
  ########################################
  users.users.gamer = {
    description = "User for gamescope session";
    isNormalUser = true;
    extraGroups = [  "networkmanager" "gamemode" "audio" ];
    hashedPassword = null;
  };

  # docs: https://jovian-experiments.github.io/Jovian-NixOS/options.html
  jovian  = {
    steam = {
      enable = true; # note: also enables jovian.steamos.useSteamOSConfig! This brings several modules. Some are useless to me
      autoStart = true;
      user = "gamer";
      desktopSession = "gamescope-wayland"; # I have to change this later
    };
    steamos = {
      enableZram = false;
      enableHdmiCecIntegration = false;
    };
  };
}
