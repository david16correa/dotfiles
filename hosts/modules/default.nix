{ lib, pkgs, inputs, ... }:
let
  # I will import all directories as modules automatically
  allModules = map (module: ./. + "/${module}")(
    builtins.attrNames(
      lib.filterAttrs (entry: type: type == "directory")
      (builtins.readDir ./.)
    )
  );
in
{
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote # secure boot; defined @ ./base/default.nix
    inputs.jovian-nixos.nixosModules.default # setup for my "steam machines"; defined @ ./steamConsole/default.nix
  ] ++ allModules;

  # base is enabled by default
  my.base.enable = lib.mkDefault true;

  # some very important options that govern my modules
  # options.my = {
  # };
}
