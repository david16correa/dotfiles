{ pkgs, modulesPath, lib, ... }: {

  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.getty.helpLine = lib.mkAfter ''


    To start, clone my dotfiles and `cd` into them with `cloneDotfiles`!

    Then follow the README. Good luck!
  '';

  programs = {
    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
    };
    bash.shellAliases = {
      cloneDotfiles = "git clone https://github.com/david16correa/dotfiles /tmp/dotfiles && cd /tmp/dotfiles";
    };
  };

  environment = {
    systemPackages = with pkgs; [
      disko
      git
      btrfs-progs
      fastfetch
      ripgrep
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
