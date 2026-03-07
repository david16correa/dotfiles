# Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, unstable, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  ########################################
  # bootloeader, kernel, and fs
  ########################################

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_zen;

  fileSystems = {
    "/".options = [ "compress=zstd" "noatime" ];
    "/home".options = [ "compress=zstd" "noatime" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
  };

  services.btrfs.autoScrub = {
    enable = true;
    interval = "monthly";
    fileSystems = [ "/" ];
  };

  ########################################
  # OS basics
  ########################################

  networking.hostName = "bjork"; # Define your hostname.
  networking.networkmanager.enable = true;

  hardware.graphics.enable = true; # OpenGl/AMD
  hardware.bluetooth.enable = true;

  time.timeZone = "America/Mexico_City";
  i18n.defaultLocale = "en_US.UTF-8";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.config.allowUnfree = true;

  users.groups.keyd = { };

  users.users.david = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "keyd" ];
    shell = pkgs.zsh;
    # packages = with pkgs; [
      # tree
    # ];
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  ########################################
  # audio
  ########################################


  ########################################
  # dm and wm
  ########################################

  # services.xserver.enable = true;
  programs.niri.enable=true;
  # services.displayManager.ly.enable = true;
  services.displayManager.gdm.enable = true;

  # services.greetd = {
    # enable = true;
    # settings = {
      # default_session = {
        # command = "niri";
        # user = "david";
      # };
    # };
  # };
  
  # environment.sessionVariables = {
  #     XCURSOR_THEME = "Adwaita";
  #     XCURSOR_SIZE = "24";
  # };

  ########################################
  # program modules
  ########################################

  programs.zsh.enable = true;
  programs.firefox.enable = true;
  programs.zoxide.enable = true;
  programs.steam = {
      enable = true;
      package = unstable.steam;
  };

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
    adwaita-icon-theme
  ]++[
    unstable.vicinae
    unstable.yazi
    unstable.kitty
    unstable.neovim
    unstable.noctalia-shell
    inputs.zen-browser.packages."${pkgs.system}".default
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

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.tlp.enable = true;
  services.thinkfan.enable = true;
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

  ########################################
  # firewall
  ########################################

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;


  ########################################
  # state version @ install
  ########################################

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # no NOT change this, ever.
}
