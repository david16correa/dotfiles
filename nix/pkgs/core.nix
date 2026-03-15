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

  programs.niri = {
    enable = true;
    useNautilus = true;
  };

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
  };

  ########################################
  # system packages
  ########################################

  environment.systemPackages = with pkgs; [
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
  ];

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
    };
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

}
