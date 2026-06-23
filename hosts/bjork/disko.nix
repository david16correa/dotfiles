# IMPORTANT: change the device (line 17) before you use this!

# To destroy a drive (completely erase):
# disko --mode destroy ./disko.nix

# To apply these configs
# disko --mode format ./disko.nix

# To mount the drive once its formatted
# disko --mode mount ./disko.nix

# All together
# disko --mode destroy,format,mount ./disko.nix

{
  disko.devices.disk.nixOS = {
    device = "/dev/nvme0nX";
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          name = "boot";
          priority = 1;
          type = "EF00";
          size = "1G";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [ "umask=0077" ];
          };
        };
        root = {
          name = "root";
          size = "100%";
          content = {
            type = "btrfs";
            subvolumes = {
              "@" = {
                mountpoint = "/";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };
              "@nix" = {
                mountpoint = "/nix";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };
              "@swap" = {
                mountpoint = "/swap";
                mountOptions = [
                  "noatime"
                ];
              };
              "@home" = {
                mountpoint = "/home";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };
              "@snapshots" = {
                mountpoint = "/home/.snapshots";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };
              "@home/david/Games" = { };
            };
          };
        };
      };
    };
  };
}
