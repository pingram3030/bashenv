#!/usr/bin/env bash

function bassh {
    [[ $# -lt 1 ]] \
        && echo "Usage: bassh HOST" \
        && return \
        || local host=$1

    local rsync_opts="-av --delete --exclude={lib,profile.d}/private/ --exclude=var/"

    ssh -o PermitLocalCommand=yes -o LocalCommand="rsync ${rsync_opts} $ENV_ROOT/ ${host}:~/.bash/" ${host}
}
