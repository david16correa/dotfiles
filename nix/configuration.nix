# Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, unstable, inputs, ... }:

{
  imports =
    [
      ./hardware.nix
    ];

  ########################################
  # bootloader, kernel, fs, and swap
  ########################################
  
  /*
  Upon reinstall, remember to:
  - check and update the resume_offset kernelParam using:
    sudo btrfs inspect-internal map-swapfile -r /swap/swapfile
  - update ./hardware.nix using:
    nixos-generate-config
  - update the uuid of resumeDevice (copy from ./hardware.nix)
  */

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
    kernelPackages = pkgs.linuxPackages_zen;
    kernelParams = [ "quiet" "splash" "loglevel=3" "rd.systemd.show_status=false" "resume_offset=40698492" ];
    resumeDevice = "/dev/disk/by-uuid/a71adb85-511c-46b6-a16e-e5a6678cc2d0";
    # consoleLogLevel = 0;
  };

  fileSystems = {
    "/".options                   = [ "compress=zstd" "noatime" ];
    "/home".options               = [ "compress=zstd" "noatime" ];
    "/nix".options                = [ "compress=zstd" "noatime" ];
    "/swap".options               = [ "noatime" ];
    "/home/.snapshots".options    = [ "compress=zstd" "noatime" ];
    "/home/david/Games".options   = [ "compress=zstd" "noatime" "x-gvfs-hide" ];
  };

  zramSwap.enable = true;

  swapDevices = [{
    device = "/swap/swapfile";
    size = 32*1024; # 32GB
  }];

  ########################################
  # OS basics
  ########################################

  networking = {
    hostName = "bjork"; # Define your hostname.
    networkmanager.enable = true;
    firewall = {
      allowedTCPPorts = [ 2020 8888];
      allowedUDPPorts = [ 5353 ];
    };
  };

  hardware = {
    cpu.amd.updateMicrocode = true; # amd ucode
    graphics.enable = true; # OpenGl/AMD
    bluetooth.enable = true;
    # alsa.enablePersistence = true;
  };

  time.timeZone = "America/Mexico_City";

  i18n.defaultLocale = "en_US.UTF-8";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  users = {
    users.david = {
      description = "David";
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "keyd" ];
      shell = pkgs.zsh;
      # packages = with pkgs; [  ];
    };
    groups.keyd = { };
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  security.polkit.enable = true;

  ########################################
  # services
  ########################################

  services = {
    btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
      fileSystems = [ "/" ];
    };

    openssh = {
        enable = true;
        allowSFTP = true;
    };

    printing.enable = true;

    upower.enable = true;

    avahi = {
      enable = true;
      nssmdns4 = true;
    };

    tlp = {
        enable = true;
        settings = {
          CPU_SCALING_GOVERNOR_ON_AC="performance";
          CPU_SCALING_GOVERNOR_ON_BAT="powersave";
          CPU_ENERGY_PERF_POLICY_ON_BAT="power";
          PLATFORM_PROFILE_ON_AC="balanced";
          PLATFORM_PROFILE_ON_BAT="low-power";
          START_CHARGE_THRESH_BAT0=40;
          STOP_CHARGE_THRESH_BAT0=80;
        };
    };

    thinkfan = {
      enable = true;
      sensors = [{
        query = "/proc/acpi/ibm/thermal";
        type = "tpacpi";
        indices = [ 0 ];
      }];
      fans = [{
        query = "/proc/acpi/ibm/fan";
        type = "tpacpi";
      }];
      levels = [
        ["level auto"       0   45]   # Let BIOS handle idle (fan off/quiet)
        [2                  45  55]   # Low speed
        [4                  55  65]   # Medium speed
        [7                  65  75]   # High speed
        ["level full-speed" 75  1000] # Max speed above 75°C (safety)
      ];
    };
  };

  systemd.services = {
    tlp-resume = {
      description = "Reapply TLP settings after resume";
      wantedBy = [ "post-resume.target" ];
      after = [ "post-resume.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.tlp}/bin/tlp start";
      };
    };
  };

  ########################################
  # state version @ install
  ########################################

  /*
  This option defines the first version of NixOS you have installed on this particular machine,
  and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.

  Most users should NEVER change this value after the initial install, for any reason,
  even if you've upgraded your system to a new NixOS release.

  This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  to actually do that.

  This value being lower than the current NixOS release does NOT mean your system is
  out of date, out of support, or vulnerable.

  Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  and migrated your data accordingly.

  For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  */

  system.stateVersion = "25.11"; # no NOT change this
}
