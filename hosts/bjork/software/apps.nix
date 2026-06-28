{ config, lib, pkgs, inputs, ... }:

{
  ########################################
  # program modules
  ########################################

  programs = {
    evince.enable = true;
    gnome-disks.enable = true;
    niri.useNautilus = true;
    nautilus-open-any-terminal = {
      enable = true;
      terminal = "kitty";
    };
  };

  ########################################
  # system packages
  ########################################

  environment.systemPackages = with pkgs; [
    nautilus
    gparted # graphical disk partitioning tool

    gnome-boxes # virtual machines viwer/manager
    dnsmasq # VM networking
    phodav # share files with guest VMs
  ];

  ########################################
  # virtualization setup
  ########################################

  virtualisation = {
    libvirtd.enable = true;
    spiceUSBRedirection.enable = true; # Enable USB redirection (for device passthrough)
  };

  # Allow VM management
  users.groups.libvirtd.members = [ "david" ];
  users.groups.kvm.members = [ "david" ];

  ########################################
  # services
  ########################################

  services = {
    flatpak.enable = true;
    gnome.sushi.enable = true;
    gnome.tinysparql.enable = true;
    gvfs.enable = true;
  };

}
