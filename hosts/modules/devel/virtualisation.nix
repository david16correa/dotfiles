{ lib, config, pkgs, ... }:
let
  cfg = config.my.devel.virtualisation;
in
{
  options.my.devel.virtualisation = {
    enable = lib.mkEnableOption "My virtualisation module";
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      gparted
      gnome-boxes
      dnsmasq # VM networking
      phodav # share files with guest VMs
    ];

    virtualisation = {
      libvirtd.enable = true;
      spiceUSBRedirection.enable = true; # Enable USB redirection (for device passthrough)
    };

    # Allow VM management
    users.groups = {
      libvirtd.members = [ "david" ];
      kvm.members = [ "david" ];
    };


  };
}
