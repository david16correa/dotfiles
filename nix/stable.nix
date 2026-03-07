{ config, lib, pkgs, inputs, ... }:

{
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

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.gnome.sushi.enable = true;

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
}
