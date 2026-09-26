# Some notes I've taken

## Setting up `~/.config/zen/my-profile`, and its backup

- Zen Browser's profile directory stores all user-specific data, which is often sensitive. Zen uses it to ensure settings persist even if the browser is uninstalled, which means it is probably worthwhile backing it up. Key contents include:
  - Browsing Data
  - Extensions
  - Session state
  - Security & configuration
  - Backups & cache
- The default profile directory is likely in `~/.config/zen/somerandomstring.Default Profile`; you can instead use `~/.config/zen/my-profile` as follows:
  - Go to `about:profiles`
  - Create a new profile
  - Select "Choose Folder", and point it to `~/.config/zen/my-profile`
- With this in mind, I created `~/Dropbox/misc/zen-profile.tar.gz.gpg`, an encrypted backup, with:

```bash
tar czf - -C ~/.config/zen/ my-profile | gpg --symmetric --cipher-algo AES256 -o ~/Dropbox/misc/zen-profile.tar.gz.gpg
```

>[!NOTE]
> - Ensure Zen Browser isn't running while doing this.
> - I would've backed up `zen-profile.tar.gz.gpg` here in my dotfiles repo, but it's too large (~500 M)
> - pw hint: ptm

- To then restore it, use:

```bash
gpg -d ~/Dropbox/misc/zen-profile.tar.gz.gpg | tar xzf - -C ~/.config/zen my-profile
```

## Some useful stuff to manage disks

- `fdisk` - create and manage partitions; this is the ol' reliable
- `cfdisk` - like `fdisk`, but with a TUI (curses-based)
- `sfdisk` - useful to restore partition layouts:

```sh
sudo sfdisk -d /dev/sdX > partitions.dump # backup the partition layout to a file
sudo sfdisk /dev/sdY < partitions.dump # restore a partition layout
```

- `partclone.somefs` - copy and restore partitions to and from an image. E.g.

```sh
sudo partclone.btrfs \  # ext(2,3,4), btrfs, xfs, ntfs, fat(12/16/32), exfat, and more
    -c \                # --clone
    -s /dev/sdXn \      # --source
    -o /dev/sdYn        # --output
```

- `btrfs` can resize:

```sh
sudo btrfs filesystem resize max /path/to/mountpoint
```

 - `btrfs` can also back up/restore volumes with `send`/`receive`:

```sh
# 1. Create Snapshot.- Generate a read-only snapshot of the source subvolume
btrfs subvolume snapshot -r /source/subvol /source/snapshot

# 2. Send and Receive.- Pipe the send output directly to the receive command on the target
btrfs send /source/snapshot | btrfs receive /target/mount

# 3. Extra: Incremental Updates.- For subsequent backups, specify the previous snapshot as the parent to send only changes.
btrfs send -p /source/parent /source/new_snapshot | btrfs receive /target/mount
```

>[!NOTE]
> When in doubt, [Rescuezilla](https://rescuezilla.com/) and [Gparted](https://gparted.org/) have served me well in the past.
