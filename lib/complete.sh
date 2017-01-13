#!/usr/bin/env bash
#
# Bash tab completion is the ducks nuts.
#

export ENV_VAR_COMPLETE="${ENV_VAR}/complete"

[[ ! -d "${ENV_VAR_COMPLETE}" ]] && mkdir -p "${ENV_VAR_COMPLETE}"

# Load all dynamically generated completion files
#
for complete_file in $(find "${ENV_VAR_COMPLETE}" -type f -name '*.sh'); do
    source ${complete_file}
done

# Private Functions
#
# _complete_path is used almost exclusively by 'environment'. You parse in a
# base path that contains git repos, not the repo itself - its parent, it
# iterates through each directory looking for '.git', adds it to an array and
# then calls _create_function with the name of the containing folder and the
# array of git repos.
#
_complete_path () {
    [[ -z ${1-} ]] \
        && echoerr "Usage: ${FUNCNAME[0]} REPOS_ROOT" \
        && return \
        || local path="$1"

    local environment completion_f dir repos

    environment=$(basename ${path})
    completion_f="${ENV_VAR_COMPLETE}/${environment}.sh"

    local -a repos

    for dir in $(find ${path}/ -maxdepth 1 -type d -not -wholename '*/'); do
        [[ -d "${dir}/.git" ]] && repos+=($(basename ${dir}))
    done

    _complete_function "${environment}" ${repos[@]}
    source "${ENV_VAR_COMPLETE}/${environment}.sh"
}

# Create a completion function for $environment from an array of its subdirs
#
_complete_function () {
    local environment="$1" opts="${@:2}"

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

