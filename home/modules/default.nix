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
    inputs.lazyvim.homeManagerModules.default
  ] ++ allModules;

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
