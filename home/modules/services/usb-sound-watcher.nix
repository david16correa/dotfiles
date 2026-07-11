{ lib, config, pkgs, inputs, ... }:
let
  cfg = config.my.usb-sound-watcher;

  usbSoundWatcher = pkgs.writeShellApplication {
    name = "usb-sound-watcher";
    runtimeInputs = with pkgs; [ udev libcanberra-gtk3 ];
    text = /*bash*/''
      udevadm monitor --udev --subsystem-match=usb_power_delivery --subsystem-match=scsi_device | \
      while read -r line; do
        case "$line" in
          *"add"*"usb_power_delivery"*)    canberra-gtk-play -i power-plug ;;
          *"remove"*"usb_power_delivery"*) canberra-gtk-play -i power-unplug ;;
          *"add"*"scsi_device"*)           canberra-gtk-play -i device-added ;;
          *"remove"*"scsi_device"*)        canberra-gtk-play -i device-removed ;;
        esac
      done
    '';
  };
in
{
  options.my.usb-sound-watcher = {
    enable = lib.mkEnableOption "enable my usb sound watcher";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ usbSoundWatcher ];

    systemd.user.services.usb-sound-watcher = {
      Unit = {
        Description = "Play a sound on USB power-delivery / SCSI device add-remove";
        After = [ "graphical-session-pre.target" ];
      };
      Service = {
        ExecStart = "${usbSoundWatcher}/bin/usb-sound-watcher";
        Restart = "on-failure";
        RestartSec = 2;
      };
      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
