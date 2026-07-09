{ lib, pkgs, inputs, ... }:
{
  imports = [
    inputs.lazyvim.homeManagerModules.default
    inputs.scientific-fhs.nixosModules.default

    ./terminal.nix
    ./desktop.nix
    ./apps.nix
    ./office.nix

    ./submodules/lazyvim.nix
    ./submodules/flatpak.nix
  ];

  # some very important options that govern my modules
  options.my = {
    gpu = lib.mkOption {
      type = lib.types.enum [ "none" "amd" "intel" "nvidia" ];
      default = "none";
      example = "amd";
      description = "GPU vendor. Used to choose vendor-specific tools";
    };
  };

}
