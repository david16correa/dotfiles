{ lib, config, pkgs, ... }:
let
  cfg = config.my.base;
in
  {
  options.my.base = {
    enable = lib.mkEnableOption "My base module";
  };

  config = lib.mkIf cfg.enable {
    ########################################
    # bootloader, kernel, boot, zswap
    ########################################
    boot = {
      loader = {
        systemd-boot.enable = false;
        efi.canTouchEfiVariables = true;
        timeout = 0;
      };

      lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
      };

      # kernelPackages = pkgs.linuxPackages_zen;

      # patch - Build failure: linux_7_2.ddcci-driver #554041 - https://github.com/NixOS/nixpkgs/issues/554041
      kernelPackages = # Remove when upstream fix is done
        let
          patch = p: p.extend(self: super: {
            ddcci-driver = super.ddcci-driver.overrideAttrs (fin: prev: {
              src = pkgs.fetchFromGitLab {
                # https://gitlab.com/dkadioglu/ddcci-driver-linux/-/tree/replace-strncpy-strscpy
                owner = "dkadioglu";
                repo = "ddcci-driver-linux";
                rev = "db5d6b87b2c85ff91a4470c50a4da99534d9917c";
                hash = "sha256-l8e9J2ZVtH5rJ47toi+A1K0mneQu1W/ik2cQHz7QRwY=";
              };
            });
          });
        in patch pkgs.linuxPackages_zen;

      consoleLogLevel = 3; # only error conditions, or more severe messages, are printed
      kernelParams = [
        ####################
        # silent boot
        ####################
        "quiet" "loglevel=3" "systemd.show_status=auto" "rd.udev.log_level=3"
        ####################
        # zswap
        ####################
        "zswap.enabled=1"
        "zswap.compressor=zstd" # compression algorithm
        "zswap.max_pool_percent=20" # maximum percentage of RAM that zswap is allowed to use; increase if you Regularly hit high memory usage, or want to avoid disk swap at almost any cost
        "zswap.zpool=z3fold" # compressed page allocator (higher density than default zbud)
        "zswap.shrinker_enabled=1" # whether to shrink the pool proactively on high memory pressure
      ];
    };

    environment.systemPackages = with pkgs; [ sbctl ];

    ########################################
    # OS basics
    ########################################
    time.timeZone = lib.mkDefault "America/Mexico_City";

    i18n.defaultLocale = "en_US.UTF-8";

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    users = {
      mutableUsers = false;
      users.david = {
        description = "David";
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" "i2c" "gamemode" ];
        hashedPassword = "$y$j9T$yNyeMYT74OLfNvm0pWp3d/$8J2m/SIw0SfwlkNcTcaY3S9xb5zkehA/YFeFLmHMxOB"; # I used `mkpasswd` to generate this!
      };
      users.root.hashedPassword = null;
    };

    programs.nh = {
      enable = true;
      clean = {
        enable = true;
        dates = "weekly";
        extraArgs = "--keep-since 30d";
      };
    };

    ########################################
    # most important services
    ########################################
    services = {
      zerotierone.enable = true;
      fstrim.enable = true;
      btrfs.autoScrub = {
        enable = true;
        interval = "weekly";
        fileSystems = [ "/" ];
      };
      openssh = {
        enable = true;
        settings.PermitRootLogin = "no";
        allowSFTP = true;
      };
    };
  };
}
