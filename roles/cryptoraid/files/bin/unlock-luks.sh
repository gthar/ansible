#!/bin/sh

. /usr/local/etc/unlock-luks.conf
. /usr/local/share/unlock-luks-helpers.sh

REMOTE_UNLOCK=/usr/local/bin/remote-unlock.sh

DROPBEAR_PORT="${DROPBEAR_PORT:-22}"
TIMEOUT="${TIMEOUT:-60}"
YK_SLOT="${YK_SLOT:-2}"

[ -z "$YK_CHALLENGE" ] && return 1
[ -z "$SOURCE_UUIDS" ] && return 1
[ -z "$TARGETS" ] && return 1

loop() {
    starttime=$(date +%s)
    usedtime=0
    while ! check_is_open && [ "$usedtime" -le "$TIMEOUT" ]; do
        while [ -f "$LOCK_FILE" ]; do
            sleep 1
        done
        yk_decrypt
        sleep 1
        endtime=$(date +%s)
        usedtime=$((endtime - starttime))
    done
}

dropbear \
    -R -s -F \
    -G root \
    -p "${DROPBEAR_PORT}" \
    -c "${REMOTE_UNLOCK}" &
DROPBEAR_PID="$!"
sleep 0.5
# shellcheck disable=SC2064
trap "kill $DROPBEAR_PID" EXIT

loop

kill "${DROPBEAR_PID}"

if check_is_open; then
    printf "decryption succeeded\n"
else
    printf "decryption failed\n"
fi
