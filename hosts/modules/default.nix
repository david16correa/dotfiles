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
    inputs.lanzaboote.nixosModules.lanzaboote
  ] ++ allModules;

  # some very important options that govern my modules
  # options.my = {
  # };
}
