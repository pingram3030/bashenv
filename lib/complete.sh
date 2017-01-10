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

# Private Functions
#
_complete_path () {
    # Find all directories (git repos) in the provided directory and create a
    # bash completion function
    [[ -z ${1-} ]] \
        && echoerr "Usage: ${FUNCNAME[0]} REPOS_ROOT" \
        && return

    local path="$1"
    local environment=$(basename ${path})
    local completion_f="${ENV_VAR_COMPLETE}/${environment}.sh"
    local state_label="complete-${environment}"

    if state_test "${state_label}" 60; then
        source "${completion_f}"
        return 0
    fi

    local -a repos

    for dir in $(find ${path}/ -maxdepth 1 -type d -not -wholename '*/'); do
        [[ -d "${dir}/.git" ]] && repos+=($(basename ${dir}))
    done

    _complete_single "${environment}" ${repos[@]}
    source "${ENV_VAR_COMPLETE}/${environment}.sh"

    state_set "${state_label}"
}

_complete_single () {
    # Create a completion function for the environment from an array of its
    # subdirectories
    local environment="$1"
    local opts="${@:2}"

    cat > "${ENV_VAR_COMPLETE}/${environment}.sh" <<EOF
#!/usr/bin/env bash
#
# Completion file for ${environment}
#

_${environment} () {
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

complete -F _${environment} ${environment}

EOF

    source "${ENV_VAR_COMPLETE}/${environment}.sh"
}

