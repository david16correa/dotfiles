# flatpak docs: https://flatpak.org/setup/NixOS
{ lib, config, pkgs, ... }:
let
  cfg = config.my.flatpak;

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
      # I use a cache to skip this entire activation script if the desired applications have not changed!
      if ! ${pkgs.busybox}/bin/cmp -s ${appList} /var/cache/flatpak-appList; then
        # 0. preamble: I save my installed and my desired apps in an array
        mapfile -t installedApps < <(${pkgs.flatpak}/bin/flatpak list --app --columns=application)
        mapfile -t desiredApps < ${appList}

        # 1. sanity check: add the flathub repository
        ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

        # 2. cleanup
        # If an installed app is no longer desired, it gets removed
        for installedApp in "''${installedApps[@]}"; do
          ${pkgs.busybox}/bin/grep "''$installedApp" ${appList} || ${pkgs.flatpak}/bin/flatpak uninstall -y --noninteractive ''${installedApp} >/dev/null 2>&1
        done
        # unused stuff is also removed
        ${pkgs.flatpak}/bin/flatpak remove --unused --noninteractive >/dev/null 2>&1

        # 3. all my apps are installed
        echo -e -n "Flatpak:"
        ${pkgs.flatpak}/bin/flatpak install -y "''${desiredApps[@]}"

        # 4. update the cache
        cat ${appList} > /var/cache/flatpak-appList
      fi
    '';
  };
}
