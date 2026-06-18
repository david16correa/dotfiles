# Some useful stuff to manage disks

- `fdisk` - create and manage partitions; this is the ol' reliable
- `cfdisk` - like `fdisk`, but graphical
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

 - `btrfs` can also backup/restore volumes with `send`/`receive`:

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
