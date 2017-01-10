#!/usr/bin/env bash
#
# Setup script for BashEnv
#

set -e
[[ ${DEBUG-} ]] && set -x

BASHRC="${HOME}/.bashrc"
SOURCE="source \${HOME}/.bash/bashrc"
BASHENV_SOURCE_PATH="$(dirname $(readlink -f $0))"

echo "You are about to setup your system for using BashEnv"
echo
echo "Enter to continue; Ctrl-C to cancel"
read

[[ ! -d "${HOME}/.bash" ]] \
  && echo "Creating BashEnv symlink" \
  && ln -vs "${BASHENV_SOURCE_PATH}" "${HOME}/.bash"

[[ $(grep -c "${SOURCE}" ${BASHRC} || true) == 0 ]] \
  && echo "Adding a source to ~/.bashrc" \
  && echo -e "\n# BashEnv\n${SOURCE}" >> ${BASHRC} \
  && source ${BASHRC}

echo "If you are reading this setup succeeded. Have a nice day :)"
