{ lib, config, pkgs, ... }:
let
  cfg = config.my.wm;
in
{
  options.my.wm = {
    enable = lib.mkEnableOption "My window manager module (niri)";
  };

  config = lib.mkIf cfg.enable {
    ########################################
    # program modules
    ########################################
    programs = {
      niri = {
        enable = true;
        useNautilus = true;
      };
      evince.enable = true;
      gnome-disks.enable = true;
      nautilus-open-any-terminal = {
        enable = true;
        terminal = "kitty";
      };
      dconf.enable = true; # for theming
      localsend.enable = true;
    };

    ########################################
    # system packages
    ########################################
    environment.systemPackages = with pkgs; [
      nautilus
      xwayland-satellite
    ];

    ########################################
    # services
    ########################################
    services = {
      ddccontrol.enable = true; # edit display parameters; e.g. brightness
      gnome.sushi.enable = true;
      gnome.tinysparql.enable = true;
      gvfs.enable = true;
      pipewire = {
        enable = true;
        pulse.enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        wireplumber.enable = true;
        jack.enable = true;
      };
    };

    ########################################
    # fonts
    ########################################
    fonts = {
      enableDefaultPackages = true;

      packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        nerd-fonts.adwaita-mono
        adwaita-fonts
        lmodern
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        noto-fonts-emoji-blob-bin
        liberation_ttf
        aileron
        inter
        eb-garamond
        cabin
        corefonts
      ];

      fontconfig = {
        defaultFonts = {
          serif = [ "Noto Serif" ];
          sansSerif = [ "Noto Sans" ];
          monospace = [ "Noto Sans Mono" ];
          emoji = [ "Blobmoji" ];
        };
      };
    };

    ########################################
    # extra
    ########################################
    hardware.alsa.enablePersistence = true;

    boot.kernelModules = [ "i2c-dev" ]; # for ddcutil to access monitor DDC/CI over I2C.

    security = {
      polkit.enable = true;
      rtkit.enable = true; # PulseAudio and PipeWire use this to acquire realtime priority
    };
  };
}
