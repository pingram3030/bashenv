#!/usr/bin/env bash

[[ ${DEBUG-} ]] && set -x
#set -u
set -o pipefail

export HISTTIMEFORMAT='%Y%m%d%H%M%S - '
HISTSIZE=1000000000

export ENV_ROOT="${HOME}/.bash"
export ENV_BASHRC="${ENV_ROOT}/bashrc"
export ENV_BIN="${ENV_ROOT}/bin"
export ENV_LIB="${ENV_ROOT}/lib"
export ENV_VAR="${ENV_ROOT}/var"

[[ -z ${PRE_ENV_PATH-} ]] && export PRE_ENV_PATH="${PATH}"

[[ ! "${PATH}" =~ "${ENV_BIN}" ]] \
    && export PATH=${ENV_BIN}:${PATH}

for lib_file in $(find ${ENV_LIB} -type f -name '*.sh'); do
    source "${lib_file}"
done

for profile_file in $(find ${ENV_ROOT}/profile.d/ -type f -name '*.sh'); do
    source "${profile_file}"
done

for complete_file in $(find "${ENV_ROOT}/completion.d/" -type f -name '*.sh'); do
    source ${completion_file}
done

