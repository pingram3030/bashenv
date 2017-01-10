#!/usr/bin/env bash

[[ ${DEBUG-} ]] && set -x
#set -u
set -o pipefail

export ENV_ROOT="${HOME}/.bash"
export ENV_BIN="${ENV_ROOT}/bin"
export ENV_LIB="${ENV_ROOT}/lib"
export ENV_VAR="${ENV_ROOT}/var"
export BASHENV="${ENV_ROOT}/bashrc"

[[ -z ${PRE_ENV_PATH-} ]] && export PRE_ENV_PATH="${PATH}"

[[ ! "${PATH}" =~ "${ENV_BIN}" ]] \
    && export PATH=${ENV_BIN}:${PATH}

for lib_file in $(find ${ENV_LIB}/ -type f -name '*.sh'); do
    source "${lib_file}"
done

for profile_file in $(find ${ENV_ROOT}/profile.d/ -type f -name '*.sh'); do
    source "${profile_file}"
done

for completion_file in $(find "${ENV_ROOT}/completion.d/" -type f -name '*.sh'); do
    source ${completion_file}
done

