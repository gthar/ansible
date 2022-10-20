#!/bin/sh

set -e

FS_ROOT="${BTRFS_ROOT:-/mnt/btr_pool}"
fstrim -v "$FS_ROOT"
