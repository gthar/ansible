#!/bin/sh

set -e

scrub_status() {
    btrfs scrub status "$@" |
        tee /dev/stderr |
        grep "^Status:" |
        awk '{ print $2}'
}

BTRFS_ROOT="${BTRFS_ROOT:-/mnt/btr_pool}"

btrfs scrub start "$BTRFS_ROOT"
sleep 10

# shellcheck disable=SC2064
trap "btrfs scrub cancel $BTRFS_ROOT" INT

printf '=================\n'
while [ "$(scrub_status "${BTRFS_ROOT}")" = "running" ]; do
    printf '________________\n'
    sleep 60
done
printf '=================\n'
