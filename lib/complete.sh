#!/usr/bin/env bash
#
# Bash tab completion is the ducks nuts.
#

source "${ENV_LIB}/state.sh"

export ENV_VAR_COMPLETE="${ENV_VAR}/complete"

[[ ! -d "${ENV_VAR_COMPLETE}" ]] && mkdir -p "${ENV_VAR_COMPLETE}"

for complete_file in $(find "${ENV_VAR_COMPLETE}" -type f -name '*.sh'); do
    source ${complete_file}
done

# Find all directories (git repos) in the provided directory and create a
# bash completion function
#
complete_path () {
    [[ -z ${1-} ]] \
        && echoerr "Usage: ${FUNCNAME[0]} REPOS_ROOT" \
        && return

    local path="$1"
    local app=$(basename ${path})
    local completion_f="${ENV_VAR_COMPLETE}/${app}.sh"
    local state_label="complete-${app}"

    if state_test "${state_label}" 60; then
        source "${completion_f}"
        return 0
    fi

    local -a repos

    for dir in $(find ${path}/ -maxdepth 1 -type d -not -wholename '*/'); do
        [[ -d "${dir}/.git" ]] && repos+=($(basename ${dir}))
    done

    _complete_single "${app}" ${repos[@]}
    source "${ENV_VAR_COMPLETE}/${app}.sh"

    state_set "${state_label}"
}

# Create a completion function for the app from an array of its subdirectories
#
_complete_single () {
    local app="$1"
    local opts="${@:2}"

    cat > "${ENV_VAR_COMPLETE}/${app}.sh" <<EOF
#!/usr/bin/env bash
#
# Completion file for ${app}
#

_${app} () {
    local cur prev opts
    COMPREPLY=()
    cur="\${COMP_WORDS[COMP_CWORD]}"
    prev="\${COMP_WORDS[COMP_CWORD-1]}"
    opts="${opts}"

    if [[ \$COMP_CWORD -eq 1 ]] ; then
        COMPREPLY=( \$(compgen -W "\${opts}" -- \${cur}) )
        return 0
    fi
}

complete -F _${app} ${app}

EOF

    source "${ENV_VAR_COMPLETE}/${app}.sh"
}

