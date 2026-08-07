{ config, lib, pkgs, inputs, ... }:
let
  hmPath = "${config.home.homeDirectory}/.dotfiles/home"; # for absolute paths in outOfStoreSymlinks

  # all extra configs are enabled
  extraConfigs = lib.mapAttrs (_: attrs:
    attrs // { enable = true; }
  ) config.my.configs.extra;

  # mkLink is the sauce
  mkLink = someConfig:
    lib.mkIf someConfig.enable (
      if someConfig.recursive or false then # makes someConfig.recursive optional
        mkRecursiveLink someConfig.source someConfig.target
      else
        mkSingleLink someConfig.source someConfig.target
    );

  mkSingleLink = source: target:
    let
      targets = if builtins.isString target then
        [target]
      else target;
    in
      builtins.listToAttrs (
        map (target: {
          name = target;
          value.source = config.lib.file.mkOutOfStoreSymlink "${hmPath}/${source}";
        }) targets
      );

  mkRecursiveLink = source: target:
    let
      files = builtins.attrNames (builtins.readDir (../.. + "/${source}")); # relative source is used (impurity is avoided!)
      targets = if builtins.isString target then [target] else target;
    in
      builtins.listToAttrs (
        lib.concatMap (target:
          map (file: {
            name = "${target}/${file}";
            value.source = config.lib.file.mkOutOfStoreSymlink "${hmPath}/${source}/${file}";
          }) files
        ) targets
      );
in {
  imports = [
    ./options.nix
  ];

  # everything under my.configs is linked as `home.file.<name>.source = config.lib.file.mkOutOfStoreSymlink "some/path"`
  config.home.file = lib.mkMerge(
    map mkLink (
      lib.attrValues (
        # the values of any config must contain a source and a target
        lib.filterAttrs (n: v: v ? source && v ? target) (config.my.configs // extraConfigs)
      )
    )
  );

  # options.my.debug = {
  #   foo = lib.mkOption {
  #     type = lib.types.attrs;
  #   };
  # };
  # config = {
  #   my.debug.foo = lib.mkMerge(lib.mapAttrsToList mkLink (
  #     lib.filterAttrs (n: v:
  #       v ? source && v ? target # the values of any config must contain a source and a target
  #     ) (config.my.configs // extraConfigs)
  #   ));
  #   xdg.configFile = {
  #     "hmAux/attrset.json".text = builtins.toJSON config.my.configs;
  #     "hmAux/debug.json".text = builtins.toJSON config.my.debug.foo;
  #   };
  # };

}
