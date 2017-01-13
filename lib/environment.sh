#!/usr/bin/env bash
#
# For intents and purposes 'environment' is a private set of git repos for a
# single job/customer. In the case that one employer uses several git repos,
# they will be checked out in to an 'environment' directory. A special function
# is also be created to assist with accessing the repos and keeping them up to
# date.
#

source ${ENV_LIB}/common.sh

export ENV_VAR_ENVIRONMENT="${ENV_VAR}/environment"

[[ ! -d "${ENV_VAR_ENVIRONMENT}" ]] && mkdir -p "${ENV_VAR_ENVIRONMENT}"

# Load all dynamically generated environment files
#
for env_file in $(find ${ENV_VAR_ENVIRONMENT} -type f -name '*.sh'); do
    source ${env_file}
done

# Public Functions
#
# The 'environment' function creates a tool to easily access git repositories.
# It enables the separation of git repos and creates a handy bash completion
# function to help access them.
#
function environment {
    [[ -z ${1-} ]] \
        && _environment_usage \
        && return 0
    local environment_path=$1
    if [[ -d ${environment_path} ]]; then
        _environment_function ${environment_path}
        _complete_path ${environment_path}
    else
        echoerr "ERROR: path '${environment_path}' does not exist as a directory"
        _environment_usage
        return 1
    fi
}

# Private Functions
#
function _environment_usage {
    echoerr "Usage: environment PATH"
    echoerr "Creates a function and completion file for managing git repos"
}

function _environment_function {
    local path="$1" environment function_f

    environment=$(basename ${path})
    function_f="${ENV_VAR_ENVIRONMENT}/${environment}.sh"

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

