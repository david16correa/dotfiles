{ pkgs, modulesPath, lib, ... }: {

  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  programs.vim.enable = true;

  environment = {
    systemPackages = with pkgs; [
      disko
      git
      btrfs-progs
      fastfetch
      stow
      tealdeer
      tmux
      btop
      partclone
      keyd
    ];
    etc."keyd/keyboard.conf".source = ./etc/keyd/keyboard.conf;
  };

  services.keyd.enable = true;
}
