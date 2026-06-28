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
    resumeDevice = "/dev/disk/by-uuid/a71adb85-511c-46b6-a16e-e5a6678cc2d0";
    # consoleLogLevel = 0;
  };

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
    hostName = "bjork"; # Define your hostname.
    networkmanager = {
      enable = true;
      wifi.powersave = false;
    };
    firewall.allowedTCPPorts = [8888]; # jupyter
  };

  hardware = {
    cpu.amd.updateMicrocode = true; # amd ucode
    alsa.enablePersistence = true;
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

  powerManagement.powerDownCommands = ''
    systemctl stop thinkfan.service
  '';

  powerManagement.resumeCommands = ''
    sleep 1
    systemctl start thinkfan.service
    systemctl start tlp.service
  '';

  time.timeZone = "America/Mexico_City";

  i18n.defaultLocale = "en_US.UTF-8";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  users = {
    mutableUsers = false;
    users.david = {
      description = "David";
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "i2c" "gamemode" ];
      shell = pkgs.zsh;
      # I used `mkpasswd` to generate this!
      hashedPassword = "$y$j9T$yNyeMYT74OLfNvm0pWp3d/$8J2m/SIw0SfwlkNcTcaY3S9xb5zkehA/YFeFLmHMxOB";
      # packages = with pkgs; [  ];
    };
    users.root.hashedPassword = null;
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true; # PulseAudio and PipeWire use this to acquire realtime priority
  };

  ########################################
  # services
  ########################################

  systemd.services.NetworkManager-wait-online.enable = false;

  services = {
    printing.enable = true;
    ddccontrol.enable = true;
    upower.enable = true;

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

    avahi = {
      enable = true;
      nssmdns4 = true;
    };

    tlp = {
      enable = true;
      settings = {
        # CPU on AC
        CPU_SCALING_GOVERNOR_ON_AC="powersave";
        CPU_ENERGY_PERF_POLICY_ON_AC="balance_performance";
        PLATFORM_PROFILE_ON_AC="balanced";
        # CPU on BAT
        CPU_SCALING_GOVERNOR_ON_BAT="powersave";
        CPU_ENERGY_PERF_POLICY_ON_BAT="power";
        PLATFORM_PROFILE_ON_BAT="low-power";
        # battery thresholds
        START_CHARGE_THRESH_BAT0=40;
        STOP_CHARGE_THRESH_BAT0=80;
        # bluetooth stuff
        USB_EXCLUDE_BTUSB=1;
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

  system.stateVersion = "26.05"; # do NOT change this, unless you know what you're doing
}
