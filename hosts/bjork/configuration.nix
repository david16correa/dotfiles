{ config, lib, pkgs, inputs, ... }:

{
  ########################################
  # bootloader, kernel, etc
  ########################################

  boot = {
    kernelParams = [
      "resume_offset=40698492"  # for hibernation
      "pcie_aspm=off"
    ];
    extraModprobeConfig = ''
      options btusb enable_autosuspend=n
    '';
  };

  ########################################
  # OS basics
  ########################################

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
    };
  };

  ########################################
  # services
  ########################################

  systemd.services.sleep-hooks = {
    description = "Sleep Hooks";
    wantedBy = [ "sleep.target" ];
    before = [ "sleep.target" ];
    unitConfig.StopWhenUnneeded = true;
    # pre-sleep script
    script = /*bash*/''
        systemctl stop tlp.service
        systemctl stop thinkfan.service
        '';
        # resume script
        postStop = /*bash*/''
        systemctl start thinkfan.service
        systemctl start tlp.service
        '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  services = {
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

    # I got tired of the F4 LED being always on. I can't fix it. This udev rule
    # makes the F4 LED be permanently off.
    udev.extraRules = ''
      SUBSYSTEM=="leds", KERNEL=="platform::micmute", ACTION=="add", ATTR{brightness}="0"
    '';
  };
}
