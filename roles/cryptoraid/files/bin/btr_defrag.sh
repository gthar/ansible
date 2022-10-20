#!/bin/sh

set -e

defragment() {
    btrfs filesystem defragment -v -r -czstd "$@"
}

list_subvols() {
    btrfs subvolume list "$@" | awk '{ print $9 }'
}

is_readonly() {
    btrfs subvolume show "$@" | grep -q "readonly"
}

BTRFS_ROOT="${BTRFS_ROOT:-/mnt/btr_pool}"

for subvol in $(list_subvols "$BTRFS_ROOT"); do
    subvol_path="$BTRFS_ROOT"/"$subvol"
    is_readonly "$subvol_path" || defragment "$subvol_path"
done
