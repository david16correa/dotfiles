{ config, lib, pkgs, inputs, ... }:

{
  ########################################
  # dm and wm
  ########################################

  # services.xserver.enable = true;
  programs.niri.enable=true;
  services.displayManager.gdm.enable = true;

  ########################################
  # program modules
  ########################################

  programs.zsh.enable = true;
  programs.firefox.enable = true;
  programs.zoxide.enable = true;
  programs.niri.useNautilus = true;

  ########################################
  # system packages
  ########################################

  environment.systemPackages = with pkgs; [
    git
    vim
    tmux
    fastfetch
    oh-my-posh
    wget
    stow
    fzf
    btop-rocm
    lsd
    tree
    bat
    tealdeer
    which
    bluetui
    rsync
    caligula
    xwayland-satellite
    trashy
    glibc
    keyd
    gum
    killall
    nautilus
    pavucontrol
    # adwaita-icon-theme
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.adwaita-mono
    adwaita-fonts
    lmodern
  ];

  ########################################
  # services
  ########################################

  services.openssh.enable = true;

  services.printing.enable = true;

  services.upower.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.gnome.sushi.enable = true;

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
  systemd.services.keyd = {
    description = "key remapping daemon";
    enable = true;
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.keyd}/bin/keyd";
    };
    wantedBy = [ "sysinit.target" ];
    requires = [ "local-fs.target" ];
    after = [ "local-fs.target" ];
  };
}
