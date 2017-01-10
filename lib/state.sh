#!/usr/bin/env bash

export ENV_VAR_STATE="${ENV_VAR}/state"

[[ ! -d "${ENV_VAR_STATE}" ]] && mkdir -p "${ENV_VAR_STATE}"  

state_test () {
    local environment=$1
    local minutes=$2
    [[ ! ${minutes} =~ ^[0-9]+$ ]] \
        && echoerr "ERROR: state_test function error. minutes not defined as integer '${minutes}'" \
        && return 255

    local state_file="${ENV_VAR_STATE}/${environment}"
    [[ ! -f "${state_file}" ]] && echo 0 > ${state_file}
    local state_seconds=$(grep -Po "\d+" ${state_file})

    local now=$(date +%s)
    local seconds=$((${minutes} * 60))
    local age=$((${now} - ${seconds}))

    [[ ${age} -lt ${state_seconds} ]] \
        && return 0 \
        || return 1
}

state_set () {
    local environment=$1
    local state_file="${ENV_VAR_STATE}/${environment}"
    local seconds=$(date +%s)
    echo ${seconds} > ${state_file} \
        && return 0 \
        || return 1
}

state_remove () {
    local environment=$1
    local state_file="${ENV_VAR_STATE}/${environment}"
    rm -f ${state_file} \
        && return 0 \
        || return 1
}

