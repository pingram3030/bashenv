#!/usr/bin/env bash

export VIMRC=$HOME/.vimrc

if [[ ! -f ${VIMRC} ]]; then
    cp ${ENV_ROOT}/profile.d/vim/vimrc ${VIMRC}
fi

# If you are editing an empty file, vim can automatically create the file from
# a known template based on the file extension.
#
VIM_TEMPLATE_EXTENSIONS=(py rb sh)

for extension in ${VIM_TEMPLATE_EXTENSIONS}; do
    [[ $(grep -c template\.${extension} ${VIMRC} || true) == 0 ]] \
        && echo "autocmd BufNewFile *.${extension} 0r ${ENV_ROOT}/profile.d/vim/template.${extension}" >> ${VIMRC}
done

