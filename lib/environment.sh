#!/usr/bin/env bash
#
# For intents and purposes 'environment' is a private set of git repos for a
# single job/customer. In the case that one employer uses several git repos,
# they will be checked out in to an 'environment' directory. A special function
# is also be created to assist with accessing the repos and keeping them up to
# date.
#

export ENV_VAR_ENVIRONMENT="${ENV_VAR}/environment"

[[ ! -d "${ENV_VAR_ENVIRONMENT}" ]] && mkdir -p "${ENV_VAR_ENVIRONMENT}"

for env_file in $(find ${ENV_VAR_ENVIRONMENT} -type f -name '*.sh'); do
    source ${env_file}
done

# Public Functions
#
environment () {
    # Several git repos may be required for a particular env. This function
    # creates a tool named for the env folder that can be tab completed and
    # that also does basic git repo update things.
    [[ -z ${1-} ]] \
        && echoerr "Usage: environment PATH" \
        && echoerr "Creates a function and completion file for managing git repos" \
        && return 0
    local environment_path=$1
    _environment_function ${environment_path}
    _complete_path ${environment_path}
}

# Private Functions
#
_environment_function () {
    local path="$1"
    local environment=$(basename ${path})
    local function_f="${ENV_VAR_ENVIRONMENT}/${environment}.sh"

    [[ -f ${function_f} ]] && return 0

    cat > ${function_f} << EOF
source \${ENV_LIB}/complete.sh

${environment} () {
    local repo=\${1-}
    [[ -z \${repo-} ]] \\
        && _complete_path ${path} \\
        && return 0
    local path="${path}/\${repo}"

    cd \${path}
    git branch
    echoerr "running 'git pull'; ctrl-c to interrupt"
    git pull
}

${environment}
EOF
    source "${function_f}"
}


