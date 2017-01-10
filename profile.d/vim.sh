#!/usr/bin/env bash

export VIMRC=$HOME/.vimrc

if [[ ! -f ${VIMRC} ]]; then
    cp ${ENV_ROOT}/profile.d/vim/vimrc ${VIMRC}
fi

# When you edit a non-existent file, vim can create the file from a template
# based on the file extension.
#
# Bash
[[ $(grep -c template\.sh ${VIMRC} || true) == 0 ]] \
    && echo "autocmd BufNewFile *.sh 0r ${ENV_ROOT}/profile.d/vim/template.sh" >> ${VIMRC}
# Ruby
[[ $(grep -c template\.rb ${VIMRC} || true) == 0 ]] \
    && echo "autocmd BufNewFile *.rb 0r ${ENV_ROOT}/profile.d/vim/template.rb" >> ${VIMRC}
