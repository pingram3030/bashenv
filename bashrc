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

[[ ! "${PATH}" =~ "${HOME}/.bash/bin" ]] \
    && export PATH=${HOME}/.bash/bin:${PATH}

source "${ENV_LIB}/app.sh"
source "${ENV_LIB}/common.sh"
source "${ENV_LIB}/complete.sh"
source "${ENV_LIB}/cred.sh"
source "${ENV_LIB}/host.sh"
source "${ENV_LIB}/state.sh"

for profile_file in $(find ${ENV_ROOT}/profile.d/ -type f -name '*.sh'); do
    source "${profile_file}"
done

for completion_file in $(find "${ENV_ROOT}/completion.d/" -type f -name '*.sh'); do
    source ${completion_file}
done

