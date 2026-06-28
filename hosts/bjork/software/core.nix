{ config, lib, pkgs, inputs, ... }:

let
  keydDevices = builtins.attrNames (builtins.readDir ./config/keyd/profiles);
in
{
  ########################################
  # dm and wm
  ########################################

  services.displayManager = {
    defaultSession = "niri";
    sddm = {
      enable = true;
      wayland.enable = true;
      wayland.compositor = "kwin";
      theme = "catppuccin-macchiato-blue";
      settings = {
        Theme = {
          CursorTheme = "Adwaita";
          CursorSize = 24;
          FacesDir="/config/sddm.extra/faces/";
        };
        Users.RememberLastSession=false;
      };
    };
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
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };
  };

  ########################################
  # system packages
  ########################################

  environment = {
    systemPackages = with pkgs; [
      sbctl
      disko
      xwayland-satellite
      keyd
      killall
      adwaita-icon-theme
      (catppuccin-sddm.override {
        flavor = "macchiato";
        accent = "blue";
        clockEnabled = false;
        font  = "Adwaita Sans";
        fontSize = "9";
        background = "${./config/sddm/dm16_10.jpg}";
        loginBackground = true;
        # userIcon = true;
      })
    ];
    etc = {
      "keyd/profiles".source = ./config/keyd/profiles;
      "sddm.extra/faces/david.face.icon".source = ./config/sddm/grinningCoffee.png;
    };
    variables = {
      EDITOR = "vim";
      VISUAL = "vim";
    };
  };

  ########################################
  # activation scripts
  ########################################

  system.activationScripts = {
    # all devices start with their default configs
    setDefaultProfiles-keyd.text = builtins.concatStringsSep "\n" (
      map (device: ''
        ln -sf "profiles/${device}/default" "/etc/keyd/${device}.conf"
      '') keydDevices
    );
  };

  ########################################
  # services
  ########################################

  services = {
    keyd.enable = true;
    zerotierone.enable = true;
    fwupd.enable = true;
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

}
