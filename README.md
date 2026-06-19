# my NixOS dotfiles

## Installation steps

- Boot into a [NixOS image](https://nixos.org/download/#nixos-iso), clone this repo, and `cd` into it:

```sh
git clone https://github.com/david16correa/dotfiles /tmp/dotfiles
cd /tmp/dotfiles
```

> [!NOTE]
> All instructions shown here assume the root of this repo is the current working directory!

- Determine the `NAME` of your drive with `lsblk`, and replace `/dev/nvme0nX` at `./nix/bjork/disko.nix` (line 17).
- Use `disko` to set up and mount the drive:

```sh
disko --mode destroy,format,mount ./nix/bjork/disko.nix

# The final partitions, subvolumes, and mountpoints are the following:
# NAME                                              MOUNTPOINT
# nvme0nX
# ├── nvme0nXp1 (size: 1G, fs: vfat)                /boot
# └── nvme0nXp2 (fs: btrfs)
#     ├── root                                      /
#     ├── nix                                       /nix
#     ├── swap                                      /swap
#     ├── home                                      /home
#     ├── snapshots                                 /home/.snapshots
#     └── games                                     /home/david/Games
```

>[!NOTE]
> For a layout different to my own, follow [NixOS' installation Guide](https://wiki.nixos.org/wiki/NixOS_Installation_Guide) up to "Format Partitions"; to set up the btrfs partition and its subvolumes, also see [this article](https://wiki.nixos.org/wiki/Btrfs#Installation_of_NixOS_on_btrfs).

- Once all partitions and subvolumes are mounted, move this repo in its intended place and `cd` into it as follows:

```sh
mv /tmp/dotfiles /mnt/home/david/.dotfiles
cd /mnt/home/david/.dotfiles
```

- Create a new `./nix/bjork/hardware.nix` with:

```sh
nixos-generate-config --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix ./nix/bjork/hardware.nix
```

- Find the UUID of your drive in `./nix/bjork/hardware.nix`, and use it to substitute `resumeDevice` in `./nix/bjork/configuration.nix`
- Update the state version at `./nix/bjork/configuration.nix` and `./nix/bjork/home/home.nix` to the current release (26.05)

> [!NOTE]
> Consider resolving all lines marked with a `stateVersion compatibility config` comment! I always try to adopt the new defaults, so reinstalling should make these lines obsolete.

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

The resulting ISO can be found in `./result/iso`. I like to flash ISOs with `caligula`.

My ISO is mostly identical to [NixOS' minimal ISO image](https://nixos.org/download/#nixos-iso), but I've included extra packages and niceties (e.g. flakes are enabled by default). You can check its configuration file at `./nix/myIso/configuration.nix`.
