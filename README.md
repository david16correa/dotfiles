# dotfiles

my NixOS dotfiles

To clone this branch:

```sh
git clone --branch nixos https://github.com/david16correa/dotfiles
```

To install, be sure to do the following:

- Follow [NixOS' installation Guide](https://wiki.nixos.org/wiki/NixOS_Installation_Guide); up to "Format Partitions"; to set up partitions and subvolumes using btrfs, also see [this article](https://wiki.nixos.org/wiki/Btrfs#Installation_of_NixOS_on_btrfs)
- Check and update the `resume_offset` kernel parameter (@ `./nix/configuration.nix`) using:

```sh
  sudo btrfs inspect-internal map-swapfile -r /swap/swapfile
```

- Update `./nix/hardware.nix` using

```sh
    nixos-generate-config
```

This will create a new `/etc/nixos/hardware-configuration.nix`.

- Update the uuid of resumeDevice (copy from `./nix/hardware.nix`)

Once everything is right, install with

```sh
nixos-install --flake './flake.nix#bjork' # make sure to run this in path/to/flake.nix!
```

> [!todo] Pendientes:
> - [ ] configurar `fprint` solo para noctalia
