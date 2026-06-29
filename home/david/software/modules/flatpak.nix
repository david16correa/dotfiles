# flatpak docs: https://flatpak.org/setup/NixOS
{ lib, config, pkgs, ... }:
let
  cfg = config.my.flatpak;

  cursorTheme = config.gtk.cursorTheme.name;
  cursorSize = config.gtk.cursorTheme.size;

  appList = pkgs.writeText "flatpak-apps" (
    lib.concatStringsSep "\n" cfg.apps
  );
in
  {
  options.my.flatpak = {
    enable = lib.mkEnableOption "Flatpak support with my custom app list in Home-Manager";

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
    home.activation.flatpak = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      # I use a cache to skip this entire activation script if the desired applications have not changed!
      if ! ${pkgs.busybox}/bin/cmp -s ${appList} ${config.home.homeDirectory}/.cache/my.flatpak/appList; then
        # 0. sanity check: add the flathub repository
        ${pkgs.flatpak}/bin/flatpak --user remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

        # 1. cleanup
        # If an installed app is no longer desired, it gets removed
        mapfile -t installedApps < <(${pkgs.flatpak}/bin/flatpak --user list --app --columns=application)
        for installedApp in "''${installedApps[@]}"; do
          ${pkgs.busybox}/bin/grep -q "''$installedApp" ${appList} || ${pkgs.flatpak}/bin/flatpak --user uninstall -y --noninteractive ''${installedApp} >/dev/null 2>&1
        done
        # unused stuff is also removed
        ${pkgs.flatpak}/bin/flatpak --user remove --unused --noninteractive >/dev/null 2>&1

        # 2. all my apps are installed (if any)
        if [ -s  ${appList} ]; then
          echo -e -n "Flatpak:"
          mapfile -t desiredApps < ${appList}
          ${pkgs.flatpak}/bin/flatpak --user install -y "''${desiredApps[@]}"
        fi

        # 3. Theming fixes
        run ${pkgs.flatpak}/bin/flatpak override --user --filesystem=${config.home.homeDirectory}/.local/share/icons:ro
        run ${pkgs.flatpak}/bin/flatpak override --user --filesystem=/nix/store:ro
        run ${pkgs.flatpak}/bin/flatpak override --user --env=XCURSOR_THEME=${cursorTheme}
        run ${pkgs.flatpak}/bin/flatpak override --user --env=XCURSOR_SIZE=${toString cursorSize}

        # 4. update the cache
        mkdir -p ${config.home.homeDirectory}/.cache/my.flatpak
        cat ${appList} > ${config.home.homeDirectory}/.cache/my.flatpak/appList
      fi
    '';
  };
}
