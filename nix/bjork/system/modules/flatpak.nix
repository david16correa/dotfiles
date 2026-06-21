# flatpak docs: https://flatpak.org/setup/NixOS
{ lib, config, pkgs, ... }:
let
  cfg = config.my.flatpak;

  flakeDir = config.my.flakeDir;

  appList = pkgs.writeText "flatpak-apps" (
    lib.concatStringsSep "\n" cfg.apps
  );
in
  {
  options.my.flatpak = {
    enable = lib.mkEnableOption "Flatpak support with my custom app list";

    package = lib.mkPackageOption pkgs "flatpak" { };

    apps = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "com.discordapp.Discord"
        "us.zoom.Zoom"
      ];
      description = "Flatpak applications to keep installed.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.flatpak.enable = true;

    system.activationScripts.flatpak.text = ''
      # I use a cache to skip this entire activation script if the desired applications has not changed!
      if ! ${pkgs.busybox}/bin/cmp -s ${appList} /var/cache/flatpak-appList; then
        # 0. preamble

        # I save my installed and my desired apps in an array
        mapfile -t installedApps < <(${pkgs.flatpak}/bin/flatpak list --app --columns=application)
        mapfile -t desiredApps < ${appList}

        # An auxiliary function
        auxFunction_isDesired(){
          local candidateApp="''$1"
          # we compare the candidate with every desired app
          for desiredApp in "''${desiredApps[@]}"; do
            # if there's a match, we return 0 (success)
            [[ "''$candidateApp" == "''$desiredApp" ]] && return 0
          done
          # else we return 1 (failure)
          return 1
        }

        # 1. Sanity check: add the flathub repository
        ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

        # 2. Cleanup
        # Remove any flatpaks I no longer want
        for installedApp in "''${installedApps[@]}"; do
          auxFunction_isDesired "''$installedApp" || ${pkgs.flatpak}/bin/flatpak uninstall -y --noninteractive ''${installedApp} >/dev/null 2>&1
        done
        # Remove any unused stuff
        ${pkgs.flatpak}/bin/flatpak remove --unused --noninteractive >/dev/null 2>&1

        # 3. Install all my apps
        echo -e -n "Flatpak:"
        ${pkgs.flatpak}/bin/flatpak install -y "''${desiredApps[@]}"

        # 4. update the cache
        cat ${appList} > /var/cache/flatpak-appList
      fi
    '';
  };
}
