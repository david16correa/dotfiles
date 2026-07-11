# Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  ########################################
  # bootloader, kernel, fs, and swap
  ########################################

  boot = {
    loader = {
      systemd-boot.enable = false;
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };

    consoleLogLevel = 3; # only error conditions, or more severe messages, are printed
    kernelPackages = pkgs.linuxPackages_zen;
    kernelParams = [
      "quiet" "loglevel=3" "systemd.show_status=auto" "rd.udev.log_level=3" # silent boot
      "resume_offset=40698492"  # for hibernation
      "zswap.enabled=1" # enables zswap
      "zswap.compressor=zstd" # compression algorithm
      "zswap.max_pool_percent=20" # maximum percentage of RAM that zswap is allowed to use; increase if you Regularly hit high memory usage, or want to avoid disk swap at almost any cost
      "zswap.zpool=z3fold" # compressed page allocator (higher density than default zbud)
      "zswap.shrinker_enabled=1" # whether to shrink the pool proactively on high memory pressure
      "pcie_aspm=off"
    ];
    extraModprobeConfig = ''
      options btusb enable_autosuspend=n
    '';
    kernelModules = [ "i2c-dev" ];
    resumeDevice = config.fileSystems."/swap".device;
  };

  environment.systemPackages = with pkgs; [ sbctl ];

  fileSystems = {
    "/".options                   = [ "compress=zstd" "noatime" ];
    "/home".options               = [ "compress=zstd" "noatime" ];
    "/nix".options                = [ "compress=zstd" "noatime" ];
    "/swap".options               = [ "noatime" ];
    "/home/.snapshots".options    = [ "compress=zstd" "noatime" ];
  };

  swapDevices = [{
    device = "/swap/swapfile";
    size = 32*1024; # 32GB
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
    # amdgpu.amdvlk = {
    #   enable = true;
    #   support32Bit.enable = true;
    # };
  };

  time.timeZone = lib.mkDefault "America/Mexico_City";

  i18n.defaultLocale = "en_US.UTF-8";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  users = {
    mutableUsers = false;
    users.david = {
      description = "David";
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "i2c" "gamemode" ];
      hashedPassword = "$y$j9T$yNyeMYT74OLfNvm0pWp3d/$8J2m/SIw0SfwlkNcTcaY3S9xb5zkehA/YFeFLmHMxOB"; # I used `mkpasswd` to generate this!
    };
    users.root.hashedPassword = null;
  };

  security.polkit.enable = true;

  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep-since 30d";
    };
  };

}
