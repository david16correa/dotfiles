{ pkgs, modulesPath, lib, ... }: {

  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
  ];

  environment.systemPackages = with pkgs; [
    neovim
    disko
    git
    btrfs-progs
    fastfetch
    stow
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
