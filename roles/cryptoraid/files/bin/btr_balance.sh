#!/bin/sh

set -e

BTRFS_ROOT="${BTRFS_ROOT:-/mnt/btr_pool}"

btrfs -v balance start --background "$BTRFS_ROOT"

# shellcheck disable=SC2064
trap "btrfs balance cancel $BTRFS_ROOT" INT

printf '=================\n'
while ! btrfs -v balance status "$BTRFS_ROOT"; do
    printf '________________\n'
    sleep 60
done
printf '=================\n'
