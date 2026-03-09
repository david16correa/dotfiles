# Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, unstable, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware.nix
    ];

  ########################################
  # bootloeader, kernel, and fs
  ########################################

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_zen;

  fileSystems = {
    "/".options = [ "compress=zstd" "noatime" ];
    "/home".options = [ "compress=zstd" "noatime" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
  };

  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
  };

  ########################################
  # OS basics
  ########################################

  networking.hostName = "bjork"; # Define your hostname.
  networking.networkmanager.enable = true;

  hardware.cpu.amd.updateMicrocode = true; # amd ucode
  hardware.graphics.enable = true; # OpenGl/AMD
  hardware.bluetooth.enable = true;

  time.timeZone = "America/Mexico_City";
  i18n.defaultLocale = "en_US.UTF-8";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  users.groups.keyd = { };

  users.users.david = {
    description = "David Correa";
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "keyd" ];
    shell = pkgs.zsh;
    # packages = with pkgs; [
      # tree
    # ];
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  ########################################
  # services
  ########################################

  services.openssh = {
      enable = true;
      allowSFTP = true;
  };

  services.zerotierone.enable = true;

  services.printing.enable = true;

  services.upower.enable = true;

  security.polkit.enable = true;

  services.udisks2.enable = true;

  # services.fprintd.enable = true; # remember to use sudo with fprint-commands!

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.tlp = {
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

  services.thinkfan = {
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

  # custom systemd services
  systemd = {
    services.keyd = {
      enable = true;
      description = "key remapping daemon";
      wantedBy = [ "sysinit.target" ];
      wants = [ "local-fs.target" ];
      after = [ "local-fs.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.keyd}/bin/keyd";
      };
    };
    user.services.polkit-gnome-authentication-agent-1 = {
      enable = true;
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
    };
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  ########################################
  # firewall
  ########################################

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;


  ########################################
  # state version @ install
  ########################################

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # no NOT change this, ever.
}
