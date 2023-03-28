#!/usr/bin/env -S just --justfile

deploy HOST *ARGS:
    ansible-playbook \
        --inventory hosts.yml \
        --vault-password-file get_password.sh \
        --limit {{HOST}} \
        {{ARGS}} \
        deploy.yml
