#!/usr/bin/env bash
#
# Common Functions
#

echoerr () {
    echo "$@" >&2
}

contains () {
    [ $# -lt 2 ] \
        && echoerr "Usage: ${FUNCNAME[0]} \$SEARCH_ITEM \${BASH_ARRAY[@]}" \
        && echoerr "  Return 0 if search_item is in bash_array, return 1 if not." \
        && return 1
    local i
    for i in "${@:2}"; do
        [[ "$i" == "$1" ]] && return 0
    done
    return 1
}

