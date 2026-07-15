# my NixOS dotfiles

## Installation steps

- Boot into a [NixOS image](https://nixos.org/download/#nixos-iso), clone this repo, and `cd` into it:

```sh
❯ git clone https://github.com/david16correa/dotfiles /tmp/dotfiles
❯ cd /tmp/dotfiles
```

> [!NOTE]
>
> - If you don't use my ISO, use the following to create a nix shell with all required packages:
>
> ``` sh
> ❯ nix shell -p vim disko git btrfs-progs
> ```
>
> - All instructions shown here assume the root of this repo is the current working directory!
> - Tip: you can use `git diff` to track your progress!

- Determine the `NAME` of your drive with `lsblk`, and replace `/dev/nvme0nX` at `./hosts/bjork/disko.nix` (line 17).
- Use `disko` to set up and mount the drive:

```sh
❯ sudo disko --mode destroy,format,mount ./hosts/bjork/disko.nix

# The final partitions, subvolumes, and mountpoints are the following:
# NAME                                              MOUNTPOINT
# nvme0nX
# ├── nvme0nXp1 (size: 1G, fs: vfat)                /boot
# └── nvme0nXp2 (fs: btrfs)
#     ├── @                                         /
#     ├── @home                                     /home
#     ├── @nix                                      /nix
#     ├── @swap                                     /swap
#     └── @snapshots                                /home/.snapshots
```

>[!NOTE]
> For a layout different to my own, follow [NixOS' installation Guide](https://wiki.nixos.org/wiki/NixOS_Installation_Guide) up to "Format Partitions"; to set up the btrfs partition and its subvolumes, also see [this article](https://wiki.nixos.org/wiki/Btrfs#Installation_of_NixOS_on_btrfs).

- Once all partitions and subvolumes are mounted, move this repo to its intended place and `cd` into it as follows:

```sh
❯ sudo mv /tmp/dotfiles /mnt/home/david/.dotfiles
❯ cd /mnt/home/david/.dotfiles
```

- Create a new `./hosts/bjork/hardware.nix` with:

```sh
❯ sudo nixos-generate-config --root /mnt
❯ cp /mnt/etc/nixos/hardware-configuration.nix ./hosts/bjork/hardware.nix
```

- Update the state version at `./hosts/bjork/default.nix` and `./home/david/default.nix` to the current release (26.05).

> [!NOTE]
> Consider resolving all lines marked with a `stateVersion compatibility config` comment! I always try to adopt the new defaults, so reinstalling should make these lines obsolete.

- Uncomment the installation patches in `./hosts/bjork/default.nix`; this will disable Lanzaboote and enable systemd-boot.

Once everything is right, install with:

```sh
❯ sudo nixos-install --flake .#bjork
```

## Post-installation steps

- Upon first boot, go to a `tty`, login, and install home-manager packages and configs:

```sh
❯ nh home switch
```

- Check and update the `resume_offset` kernel parameter in `./hosts/bjork/configuration.nix` using the output of:

```sh
❯ sudo btrfs inspect-internal map-swapfile -r /swap/swapfile
```

- Comment the installation patches in `./hosts/bjork/default.nix`.
- Set up secure boot:
  - First create the Secure Boot keys:

  ```sh
  ❯ sudo sbctl create-keys
  ```

  - Rebuild NixOS:

  ```sh
  ❯ nh os switch
  ```

  - Verify the machine is ready:

  ```sh
  ❯ sudo sbctl verify
  ```

  - Reboot into the firmware (`systemctl reboot --firmware-setup`) and enter Secure Boot Setup Mode.
  - Enroll keys:

  ```sh
  ❯ sudo sbctl enroll-keys --microsoft
  ```

  - Reboot again, and verify Secure Boot is activated with:

  ```sh
  ❯ bootctl status
  ```

>[!NOTE]
> When in doubt, check [Lanzaboote's guide](https://nix-community.github.io/lanzaboote/).

- To set up `maestral`, and start downloading my files (~ 60G):
  - Run `maestral start`; this will prompt Maestral's setup.
  - Keep `maestral` from downloading some directories:

  ```sh
  ❯ cd ~/Dropbox
  ❯ maestral excluded add "my vault" mci servers tech_support vault.lbm wallpapers
  ```

  - Once `maestral` is finished downloading, link `~/Dropbox/.Home/*`:

  ```sh
  ❯ cd ~/Dropbox
  ❯ stow .Home
  ```

- Update the NixOS' birth time in `./home/david/configFiles/fastfetch/birthTime`:

```sh
❯ echo $(stat -c %W /) > ./home/david/configFiles/fastfetch/birthTime
```

- Set up Zen Browser by hand; the extensions I use are:
  - [uBlock Origin](https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/)
  - [Keepa](https://addons.mozilla.org/en-US/firefox/addon/keepa/)
  - [Vimium C](https://addons.mozilla.org/en-US/firefox/addon/vimium-c/?src=external-readme) (my configs are `./misc/vimium_c/vimium_c-20260410_125539.json`)
  - [Zotero Connector](https://www.zotero.org/download/)
- Log in to Steam, and make sure to set up `~/Games` as the default library; it's a different subvolume, which will keep `snapper` from backing up your entire Steam library.

## Building my ISO

In this flake I also have the setup for my ISO image; build it with:

```sh
❯ nixos-rebuild build-image --image-variant iso --flake .#myIso
```

or with `nh`:

```sh
❯ nh os build-image --image-variant=iso --hostname=myIso
```

The resulting ISO will be placed in `./result/iso`. I like to flash ISOs with `caligula`.

My ISO is mostly identical to [NixOS' minimal ISO image](https://nixos.org/download/#nixos-iso), but I've included extra packages and niceties (e.g. flakes are enabled by default). You can check its configuration file at `./hosts/myIso/default.nix`.
