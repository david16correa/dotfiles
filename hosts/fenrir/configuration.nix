{ config, lib, pkgs, inputs, ... }:

{
  ########################################
  # bootloader, kernel, etc
  ########################################
  fileSystems = {
    "/".options                   = [ "compress=zstd" "noatime" ];
    "/home".options               = [ "compress=zstd" "noatime" ];
    "/nix".options                = [ "compress=zstd" "noatime" ];
    "/swap".options               = [ "noatime" ];
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

    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      wireplumber.enable = true;
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

  jovian.steam = {
    enable = true;
    autoStart = true;
    user = "gamer";
    desktopSession = "gamescope-wayland"; # I have to change this later
  };
}
