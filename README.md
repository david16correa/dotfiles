# my NixOS dotfiles

> [!NOTE]
> All instructions shown here assume the root of this repo is the current working directory!

## Installation steps

- Follow [NixOS' installation Guide](https://wiki.nixos.org/wiki/NixOS_Installation_Guide) up to "Format Partitions"; to set up the btrfs partition and its subvolumes, also see [this article](https://wiki.nixos.org/wiki/Btrfs#Installation_of_NixOS_on_btrfs). The intended partitions, subvolumes, and mountpoints are the following:

```
NAME                                              MOUNTPOINT
nvme0nX
├── nvme0nXp1 (size: 1G, fs: vfat)                /boot
└── nvme0nXp2 (fs: btrfs)
    ├── root                                      /
    ├── nix                                       /nix
    ├── swap                                      /swap
    ├── home                                      /home
    ├── snapshots                                 /home/.snapshots
    └── games                                     /home/david/Games
```

- Mount all partitions and subvolumes using:

```sh
mkdir /mnt
mount -o compress=zstd,noatime,subvol=root        /dev/nvme0nXp2 /mnt

mkdir /mnt/boot
mount /dev/nvme0nXp1 /mnt/boot

mkdir /mnt/{nix,swap,home}
mount -o compress=zstd,noatime,subvol=nix         /dev/nvme0nXp2 /mnt/nix
mount -o noatime,subvol=swap                      /dev/nvme0nXp2 /mnt/swap
mount -o compress=zstd,noatime,subvol=home        /dev/nvme0nXp2 /mnt/home

mkdir -p /mnt/home/{.snapshots,david/Games}
mount -o compress=zstd,noatime,subvol=snapshots   /dev/nvme0nXp2 /mnt/home/.snapshots
mount -o compress=zstd,noatime,subvol=games       /dev/nvme0nXp2 /mnt/home/david/Games
```

- Create a new `/mnt/etc/nixos/hardware-configuration.nix` with:

```sh
nixos-generate-config --root /mnt
```

- Use `/mnt/etc/nixos/hardware-configuration.nix` to substitute all UUIDs in `./nix/hardware.nix` and `./nix/configuration.nix`

Once everything is right, install with:

```sh
nixos-install --flake './flake.nix#bjork' # make sure to run this in path/to/flake.nix!
```

## Post-installation steps

- Check and update the `resume_offset` kernel parameter in `./nix/configuration.nix` using the output of:

```sh
  sudo btrfs inspect-internal map-swapfile -r /swap/swapfile
```

- Set up secure boot following lanzaboote's guide: first [prepare your system](https://nix-community.github.io/lanzaboote/getting-started/prepare-your-system.html), then [enable secure boot](https://nix-community.github.io/lanzaboote/getting-started/enable-secure-boot.html)
- Use `./misc/flatpak.setup` to install all applications
- Install mutable configs and custom scripts using:

```sh
stow ./stow
```

- Set up Zen Browser by hand; the extensions I use are:
  - [uBlock Origin](https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/)
  - [Keepa](https://addons.mozilla.org/en-US/firefox/addon/keepa/)
  - [Vimium C](https://addons.mozilla.org/en-US/firefox/addon/vimium-c/?src=external-readme) (my configs are `./misc/vimium c/vimium_c-20260410_125539.json`)
  - [Zotero Connector](https://www.zotero.org/download/)
