#!/usr/bin/env bash
#
# Setup script for BashEnv
#

set -e
[[ ${DEBUG-} ]] && set -x

BASHRC="${HOME}/.bashrc"
SOURCE="source \${HOME}/.bash/bashrc"
BASHENV_SOURCE_PATH="$(dirname $(readlink -f $0))"

PACKAGES=(
  python3-bashate
  rubygem-bundler
  ruby-irb
)

echo "****************************************************"
echo "You are about to setup your system for using BashEnv"
echo
echo "Enter to continue; Ctrl-C to cancel"
echo "****************************************************"
read

# ~/.bash can either be a symlink or a dir depending on personal preference
# If it doesn't exist we default to quickly symlinking to make everything work.
echo -n "Checking ~/.bash directory: "
[[ ! -d "${HOME}/.bash" ]] \
  && echo "Creating BashEnv symlink" \
  && ln -vs "${BASHENV_SOURCE_PATH}" "${HOME}/.bash" \
  || echo "OK"

# To reduce clutter in ~/.bashrc we just put in a single source that makes all
# the things JustWork™
echo -n "Checking ~/.bashrc: "
[[ $(grep -c "${SOURCE}" ${BASHRC} || true) == 0 ]] \
  && echo "Adding a source to ~/.bashrc" \
  && echo -e "\n# BashEnv\n${SOURCE}" >> ${BASHRC} \
  && source ${BASHRC} \
  || echo "OK"

# Some rpms are nice to have, some are mandatory
echo -n "Checking for needed packages: "
for package in ${PACKAGES[@]}; do
  rpm -q $package >/dev/null
  [[ $? -gt 0 ]] \
    && echo "Package '${package}' is not installed." \
    && missing+=(${package})
done
if [[ -n ${missing} ]]; then
  echo "Attempt install of packages? (y/N)"
  for i in ${missing[@]}; do
    echo "  - ${i}"
  done
  read yn
  [[ ${yn} =~ ^[y|Y]$ ]] \
    && sudo dnf -y install ${missing[@]}
fi
[[ -z ${missing-} ]] && echo "OK"

# Like it or lump it, ruby is here to stay as I know how to use it and friends
# don't let friends use bash hashes..
echo -n "Checking ruby gems: "
pushd ${BASHENV_SOURCE_PATH} > /dev/null
  if [[ -f Gemfile.lock ]]; then
    gems=($(grep ^gem Gemfile | tr -d "'" | awk '{print $NF}'))
    for gem in ${gems}; do
      [[ $(grep -c ${gem} Gemfile.lock) == 0 ]] \
        && echo "Missing gem '${gem}'; Installing." \
        && bundle install \
        || echo "OK"
    done
  else
    echo "Installing gems"
    bundle install
  fi
popd > /dev/null

echo
echo "If you are reading this, setup succeeded. Have a nice day :)"
