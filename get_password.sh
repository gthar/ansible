#!/bin/sh

PASSFILE="/srv/secrets/ansible_vault_pass"
if [ -f "$PASSFILE" ]; then
    doas cat "$PASSFILE"
else
    pass ansible-vault
fi
