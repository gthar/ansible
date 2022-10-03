#!/bin/sh

. /usr/local/etc/unlock-luks.conf
. /usr/local/share/unlock-luks-helpers.sh

[ -z "$SOURCE_UUIDS" ] && return 1
[ -z "$TARGETS" ] && return 1

touch "$LOCK_FILE"
# shellcheck disable=SC2064
trap "rm -f $LOCK_FILE" EXIT

printf "Enter LUKS password:"
passwd=$(read_password)
decrypt "${passwd}"

rm -f "$LOCK_FILE"
