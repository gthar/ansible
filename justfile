#!/usr/bin/env -S just --justfile

password_file := "get_password.sh"

# may need to use --force to reinstall all requirements
reqs *ARGS:
    ansible-galaxy install -r requirements.yaml {{ARGS}}

deploy HOST *ARGS:
    ansible-playbook \
        --inventory hosts.yml \
        --vault-password-file {{password_file}} \
        --limit {{HOST}} \
        {{ARGS}} \
        deploy.yml

# just vault (encrypt/decrypt/edit)
vault ACTION:
    EDITOR="nvim" ansible-vault {{ACTION}} \
        --vault-password-file {{password_file}} \
        vars/vault.yaml
