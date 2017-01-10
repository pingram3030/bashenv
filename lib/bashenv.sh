#!/usr/bin/env bash
#
# Basic helper functions for setting up and managing BashEnv
#

source ${ENV_LIB}/common.sh

function bashenv {
    local options=($@)
    [[ -z ${options} ]] \
        && source ${BASHENV} \
        && echoerr "BashEnv initialised" \
        || _bashenv_getopts ${options[@]}
}

function _bashenv_help {
    cat << EOF
Usage: bashenv [-h|--help] [-r|--reset] [-s|--setup]
Perform basic functions for BashEnv. The default action, when run without
options, is to 'source \${BASHENV}' (${BASHENV}) and continue.

    -h, --help      show this help and exit
    -r, --reset     remove all var files and regenerate self
    -s, --setup     install self in to the shell of user: '${USER}'
    -t, --test      run bashate, rubocop and markdownlint
EOF
}

function _bashenv_getopts {
    OPTIND=1
    local optspec=":hrst" OPTARG=($@)
    while getopts "${optspec}" opt; do
        case "${opt}" in
            h|help)
                _bashenv_help
                return 0
            ;;
            r|reset)
                _bashenv_reset
                return 0
            ;;
            s|setup)
                _bashenv_setup
                return 0
            ;;
            t|test)
                _bashenv_test
                return 0
            ;;
        esac
    done
}

function _bashenv_reset {
    echoerr "Resetting BashEnv..."
    [[ -z ${ENV_VAR} ]] \
        && echoerr "ERROR: \${ENV_VAR} is unset; run 'bashenv --setup'" \
        && return 1 \
        || rm -Rf ${ENV_VAR}/*
    echoerr "${ENV_VAR} has been reset"
    bashenv
}

function _bashenv_setup {
    echoerr "Running BashEnv setup"
    ${ENV_ROOT}/setup.sh
    bashenv
}

function _bashenv_test {
    pushd ${ENV_ROOT} >/dev/null
        echoerr "Testing shell..."
        bashate -i E006 bashrc setup.sh $(find -name "*.sh")
        echoerr "Testing markdown..."
        mdl $(find -name "*.md")
        echoerr "Testing ruby..."
        bundle exec rubocop -D
    popd >/dev/null
}
