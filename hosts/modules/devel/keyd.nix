{ lib, config, pkgs, ... }:
let
  cfg = config.my.devel.keyd;

  keydDevices = builtins.attrNames (builtins.readDir ./configFiles/profiles);
in
  {
  options.my.devel.keyd = {
    enable = lib.mkEnableOption "My keyd module";
  };

  config = lib.mkIf cfg.enable {

    environment = {
      systemPackages = with pkgs; [ keyd ];
      etc."keyd/profiles".source = ./configFiles/profiles;
    };

    system.activationScripts = {
      # all devices start with their default configs
      setDefaultProfiles-keyd.text = builtins.concatStringsSep "\n" (
        map (device: /*bash*/''
        ln -sf "profiles/${device}/default" "/etc/keyd/${device}.conf"
        '') keydDevices
      );
    };

    services.keyd.enable = true;

  };
}
