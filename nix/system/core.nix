{ config, lib, pkgs, inputs, ... }:

{
  ########################################
  # dm and wm
  ########################################

  # services.xserver.enable = true;

  services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
  };

  programs.niri.enable = true;

  ########################################
  # program modules
  ########################################

  programs = {
    zsh.enable = true;
    dconf.enable = true;
    git = {
      enable = true;
      config = {
        init.defaultBranch = "main";
        url."https://github.com/".insteadOf = [
          "gh:"
          "github:"
        ];
        user = {
          name = "David Correa";
          email = "david.correa.msc@gmail.com";
        };
      };
    };
    nh = {
      enable = true;
      flake = "/home/david/.dotfiles";
      clean = {
        enable = true;
        dates = "weekly";
        extraArgs = "--keep-since 30d";
      };
    };
  };

  ########################################
  # system packages
  ########################################

  environment = {
    systemPackages = with pkgs; [
      vim
      tmux
      fastfetch
      stow
      btop-rocm
      tree
      tealdeer
      which
      rsync
      caligula
      xwayland-satellite
      # glibc
      gcc
      keyd
      gum
      killall
      dmidecode
      gh
      polkit_gnome
      playerctl
      brightnessctl
      ddcutil
      compsize
    ];
    etc = {
      "keyd/profiles".source = ./etc/keyd/profiles;
    };
  };

  ########################################
  # services
  ########################################

  services = {
    zerotierone.enable = true;
    udisks2.enable = true;
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      wireplumber.enable = true;
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
    # I got tired of the F4 LED being always on. I can't fix it. This udev rule
    # makes the F4 LED be permanently off.
    udev.extraRules = ''
      SUBSYSTEM=="leds", KERNEL=="platform::micmute", ACTION=="add", ATTR{brightness}="0"
    '';
  };

  # custom systemd services
  systemd = {
    services = {
      keyd = {
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

}
