#!/bin/sh

. /usr/local/etc/unlock-luks.conf

export LOCK_FILE=/tmp/remote-unlock.lock

[ -z "$SOURCE_UUIDS" ] && return 1
[ -z "$TARGETS" ] && return 1

decrypt() {
    passwd="$1"
    i=1
    for uuid in $SOURCE_UUIDS; do
        target=$(printf "%s" "$TARGETS" | cut -d ' ' -f "${i}")
        printf "%s" "$passwd" | cryptsetup luksOpen "/dev/disk/by-uuid/${uuid}" "${target}"
        i=$((i + 1))
    done
}

read_password() {
    stty -echo
    trap 'stty echo' EXIT
    read -r passwd
    stty echo
    trap - EXIT
    printf "%s" "${passwd}"
}

check_is_open() {
    for target in $TARGETS; do
        [ ! -b "/dev/mapper/${target}" ] && return 1
    done
    return 0
}

yk_decrypt() {
    printf "attempting decryption with yubikey\n"
    if ykinfo "-${YK_SLOT}" >&2; then
        printf "yubikey available\n"
        yk_pass=$(ykchalresp "-${YK_SLOT}" "${YK_CHALLENGE}" | tr -d '\n')
        decrypt "$yk_pass"
    else
        printf "yubikey not present\n"
    fi
}
