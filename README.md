# my NixOS dotfiles

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
mkdir -p /mnt
mount -o compress=zstd,noatime,subvol=root        /dev/nvme0nXp2 /mnt

mkdir -p /mnt/boot
mount /dev/nvme0nXp1 /mnt/boot

mkdir -p /mnt/{nix,swap,home}
mount -o compress=zstd,noatime,subvol=nix         /dev/nvme0nXp2 /mnt/nix
mount -o noatime,subvol=swap                      /dev/nvme0nXp2 /mnt/swap
mount -o compress=zstd,noatime,subvol=home        /dev/nvme0nXp2 /mnt/home

mkdir -p /mnt/home/{.snapshots,david/Games}
mount -o compress=zstd,noatime,subvol=snapshots   /dev/nvme0nXp2 /mnt/home/.snapshots
mount -o compress=zstd,noatime,subvol=games       /dev/nvme0nXp2 /mnt/home/david/Games
```

- Once all partitions and subvolumes are mounted, clone this repo in its intended place and `cd` into it as follows:

```sh
git clone https://github.com/david16correa/dotfiles /mnt/home/david/.dotfiles
cd /mnt/home/david/.dotfiles
```

> [!NOTE]
> All instructions shown here assume the root of this repo is the current working directory!

- Create a new `./nix/bjork/hardware.nix` with:

```sh
nixos-generate-config --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix ./nix/bjork/hardware.nix
```

- Find the UUID of your drive in `./nix/bjork/hardware.nix`, and use it to substitute `resumeDevice` in `./nix/bjork/configuration.nix`
- Update the state version at `./nix/bjork/configuration.nix` and `./nix/bjork/home/home.nix` to the current release (26.05)

Once everything is right, install with:

```sh
nixos-install --flake .#bjork
```

## Post-installation steps

- Check and update the `resume_offset` kernel parameter in `./nix/configuration.nix` using the output of:

```sh
sudo btrfs inspect-internal map-swapfile -r /swap/swapfile
```

- Set up secure boot following lanzaboote's guide: first [prepare your system](https://nix-community.github.io/lanzaboote/getting-started/prepare-your-system.html), then [enable secure boot](https://nix-community.github.io/lanzaboote/getting-started/enable-secure-boot.html)
- Use `./misc/flatpak.setup` to install all flatpak applications; this script is idempotent, and is intended to be used to declaratively manage flatpaks

- Set up Zen Browser by hand; the extensions I use are:
  - [uBlock Origin](https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/)
  - [Keepa](https://addons.mozilla.org/en-US/firefox/addon/keepa/)
  - [Vimium C](https://addons.mozilla.org/en-US/firefox/addon/vimium-c/?src=external-readme) (my configs are `./misc/vimium c/vimium_c-20260410_125539.json`)
  - [Zotero Connector](https://www.zotero.org/download/)

## Building my ISO

In this flake I also have the setup for my ISO image; build it with:

```sh
nixos-rebuild build-image --image-variant iso --flake .#myIso
```

The resulting ISO can be found in `./result/iso`, and can be burned with `caligula`.
