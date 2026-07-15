{ lib, config, pkgs, ... }:
let
  cfg = config.my.services;
in
  {
  options.my.services = {
    enable = lib.mkEnableOption "My services module";
  };

  config = lib.mkIf cfg.enable {
    ########################################
    # services
    ########################################

    services = {
      printing.enable = true;
      upower.enable = true; # needed for noctalia battery widget
      udisks2.enable = true; # d-bus interfaces used to query and manipulate storage devices
      automatic-timezoned.enable = true;
      zerotierone.enable = true;
      fwupd.enable = true;
      flatpak.enable = true;

      btrfs.autoScrub = {
        enable = true;
        interval = "weekly";
        fileSystems = [ "/" ];
      };

      snapper = {
        snapshotInterval = "hourly";
        configs.home = {
          SUBVOLUME = "/home";
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

      openssh = {
        enable = true;
        settings.PermitRootLogin = "no";
        allowSFTP = true;
      };

      # makes my machine accessible in the local network
      avahi = {
        enable = true;
        nssmdns4 = true;
      };

    };

    ########################################
    # extra
    ########################################

    systemd.services.NetworkManager-wait-online.enable = false;
  };
}
