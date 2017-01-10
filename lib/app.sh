#!/usr/bin/env bash
#
# For intents and purposes 'app' is the per application/project private set of
# git repos for a job. In the case that one employer uses several git repos,
# they will be checked out in to the 'app' directory. A special 'app' function
# will also be created to assist with accessing the apps and keeping them up
# to date.
#

export ENV_VAR_APP="${ENV_VAR}/apps"

[[ ! -d "${ENV_VAR_APP}" ]] && mkdir -p "${ENV_VAR_APP}"

for app_file in $(find ${ENV_VAR_APP} -type f -name '*.sh'); do
    source ${app_file}
done

app_list () {
    [[ -z ${1-} ]] \
        && echoerr "Usage: ${FUNCNAME[0]} APP_ROOT" \
        && return

    local path="$1"
    local app
    for app in $(find ${path}/ -maxdepth 1 -type d -not -wholename '*/'); do
        basename ${app}
    done
}

_app_function () {
    local path="$1"
    local app=$(basename ${path})
    local function_f="${ENV_VAR_APP}/${app}.sh"

    [[ -f ${function_f} ]] && return 0

    cat > ${function_f} << EOF
source \${ENV_LIB}/complete.sh

${app} () {
    local repo=\${1-}
    [[ -z \${repo-} ]] \\
        && complete_path ${path} \\
        && return 0
    local path="${path}/\${app}"

    cd \${path}
    git branch
    echoerr "running 'git pull'; ctrl-c to interrupt"
    git pull
}

${app}
EOF
    source "${function_f}"
}

# Public Functions
#
app () {
    # Several git repos may be required for a particular app. This function
    # creates a tool named for the app folder that can be tab completed and
    # that also does basic git repo update things.
    [[ -z ${1-} ]] \
        && echoerr "Usage: app PATH" \
        && echoerr "Creates a function and completion file for managing git apps" \
        && return 0
    local app_path=$1
    _app_function ${app_path}
    complete_path ${app_path}
}

